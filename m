Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.eqx.gridhost.co.uk ([95.142.156.3]:46186 "EHLO
	mail2.eqx.gridhost.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbbJEWZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 18:25:26 -0400
Received: from [209.85.212.180] (helo=mail-wi0-f180.google.com)
	by mail2.eqx.gridhost.co.uk with esmtpsa (UNKNOWN:AES128-GCM-SHA256:128)
	(Exim 4.72)
	(envelope-from <olli.salonen@iki.fi>)
	id 1ZjEBn-0006SC-JJ
	for linux-media@vger.kernel.org; Mon, 05 Oct 2015 23:24:59 +0100
Received: by wicge5 with SMTP id ge5so141134173wic.0
        for <linux-media@vger.kernel.org>; Mon, 05 Oct 2015 15:24:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1443571810-5627-2-git-send-email-labbott@fedoraproject.org>
References: <1443571810-5627-1-git-send-email-labbott@fedoraproject.org>
	<1443571810-5627-2-git-send-email-labbott@fedoraproject.org>
Date: Tue, 6 Oct 2015 00:24:59 +0200
Message-ID: <CAAZRmGxi5ZZWEBKU3s0dfkqN1kdx1nYjguorcMpRv9_cVb4A7Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] si2157: Bounds check firmware
From: Olli Salonen <olli.salonen@iki.fi>
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laura,

While the patch itself does what it says, the return code for the
si2157_init will be 0 even if there's a faulty firmware file. Wouldn't
it be better to set the return code as -EINVAL like done a few lines
earlier in the code (see below)?

        if (fw->size % 17 != 0) {
                dev_err(&client->dev, "firmware file '%s' is invalid\n",
                                fw_name);
                ret = -EINVAL;
                goto err_release_firmware;
        }

Cheers,
-olli

On 30 September 2015 at 02:10, Laura Abbott <labbott@fedoraproject.org> wrote:
> When reading the firmware and sending commands, the length
> must be bounds checked to avoid overrunning the size of the command
> buffer and smashing the stack if the firmware is not in the
> expected format. Add the proper check.
>
> Cc: stable@kernel.org
> Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
> ---
>  drivers/media/tuners/si2157.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 5073821..ce157ed 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -166,6 +166,10 @@ static int si2157_init(struct dvb_frontend *fe)
>
>         for (remaining = fw->size; remaining > 0; remaining -= 17) {
>                 len = fw->data[fw->size - remaining];
> +               if (len > SI2157_ARGLEN) {
> +                       dev_err(&client->dev, "Bad firmware length\n");
> +                       goto err_release_firmware;
> +               }
>                 memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
>                 cmd.wlen = len;
>                 cmd.rlen = 1;
> --
> 2.4.3
>
