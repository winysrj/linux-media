Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.eqx.gridhost.co.uk ([95.142.156.13]:38450 "EHLO
	mail4.eqx.gridhost.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbbJHKkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Oct 2015 06:40:41 -0400
Received: from [209.85.212.182] (helo=mail-wi0-f182.google.com)
	by mail4.eqx.gridhost.co.uk with esmtpsa (UNKNOWN:AES128-GCM-SHA256:128)
	(Exim 4.72)
	(envelope-from <olli.salonen@iki.fi>)
	id 1Zk8cN-0001Eg-SY
	for linux-media@vger.kernel.org; Thu, 08 Oct 2015 11:40:11 +0100
Received: by wicge5 with SMTP id ge5so19380201wic.0
        for <linux-media@vger.kernel.org>; Thu, 08 Oct 2015 03:40:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444084409-20259-1-git-send-email-labbott@fedoraproject.org>
References: <5612F98D.4020000@redhat.com>
	<1444084409-20259-1-git-send-email-labbott@fedoraproject.org>
Date: Thu, 8 Oct 2015 13:40:11 +0300
Message-ID: <CAAZRmGyOpO3sB=CdNuAc0Rdg3PdYna45dVv-WSV-N-A9q6Y62A@mail.gmail.com>
Subject: Re: [PATCHv2] si2157: Bounds check firmware
From: Olli Salonen <olli.salonen@iki.fi>
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Olli Salonen <olli.salonen@iki.fi>
Tested-by: Olli Salonen <olli.salonen@iki.fi>


On 6 October 2015 at 01:33, Laura Abbott <labbott@fedoraproject.org> wrote:
>
> When reading the firmware and sending commands, the length
> must be bounds checked to avoid overrunning the size of the command
> buffer and smashing the stack if the firmware is not in the
> expected format. Add the proper check.
>
> Cc: stable@kernel.org
> Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
> ---
> v2: Set the return code properly
> ---
>  drivers/media/tuners/si2157.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 5073821..0e1ca2b 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -166,6 +166,11 @@ static int si2157_init(struct dvb_frontend *fe)
>
>         for (remaining = fw->size; remaining > 0; remaining -= 17) {
>                 len = fw->data[fw->size - remaining];
> +               if (len > SI2157_ARGLEN) {
> +                       dev_err(&client->dev, "Bad firmware length\n");
> +                       ret = -EINVAL;
> +                       goto err_release_firmware;
> +               }
>                 memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
>                 cmd.wlen = len;
>                 cmd.rlen = 1;
> --
> 2.4.3
>
