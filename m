Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33723 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbcHOIha (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 04:37:30 -0400
MIME-Version: 1.0
In-Reply-To: <0bf4740a-7200-c6c4-c432-6a8152dec17a@xs4all.nl>
References: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1469178554-20719-5-git-send-email-ulrich.hecht+renesas@gmail.com> <0bf4740a-7200-c6c4-c432-6a8152dec17a@xs4all.nl>
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Date: Mon, 15 Aug 2016 10:37:29 +0200
Message-ID: <CAO3366xk6hjh2abbYcXmuYKcK39Y9psgYvHkZo3FH4JbU1KY0g@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] rcar-vin: implement EDID control ioctls
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: hans.verkuil@cisco.com,
	=?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent <laurent.pinchart@ideasonboard.com>,
	William Towle <william.towle@codethink.co.uk>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 13, 2016 at 3:30 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 07/22/2016 11:09 AM, Ulrich Hecht wrote:
>> Adds G_EDID and S_EDID.
>>
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>> ---
>>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 33 +++++++++++++++++++++++++++++
>>  1 file changed, 33 insertions(+)
>>
>> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> index 396eabc..57e040c 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> @@ -661,6 +661,36 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
>>       return ret;
>>  }
>>
>> +static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
>> +{
>> +     struct rvin_dev *vin = video_drvdata(file);
>> +     int input, ret;
>> +
>> +     input = edid->pad;
>> +     edid->pad = vin->inputs[input].sink_idx;
>
> There is no vin->inputs array. Are there some other patches that need to be merged
> first?

It depends on "[PATCHv2 12/16] [media] rcar-vin: allow subdevices to
be bound late" from "[PATCHv2 00/16] rcar-vin: Enable Gen3 support".
Does that series have a chance of getting merged any time soon?

CU
Uli
