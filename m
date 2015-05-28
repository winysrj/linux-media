Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:55147 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754755AbbE1Vcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:32:39 -0400
Message-ID: <1432848754.1556.25.camel@perches.com>
Subject: Re: [PATCH 1/9] drivers/media/usb/airspy/airspy.c: drop unneeded
 goto
From: Joe Perches <joe@perches.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Antti Palosaari <crope@iki.fi>, kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 28 May 2015 14:32:34 -0700
In-Reply-To: <1432846944-7122-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1432846944-7122-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1432846944-7122-2-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2015-05-28 at 23:02 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete jump to a label on the next line, when that label is not
> used elsewhere.

Seems sensible but:

> diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
[]
> @@ -937,9 +937,6 @@ static int airspy_set_if_gain(struct airspy *s)
>  	ret = airspy_ctrl_msg(s, CMD_SET_VGA_GAIN, 0, s->if_gain->val,
>  			&u8tmp, 1);
>  	if (ret)
> -		goto err;
> -err:
> -	if (ret)
>  		dev_dbg(s->dev, "failed=%d\n", ret);
>  
>  	return ret;

Ideally the function above this should also be modified
do drop the unnecessary double test of ret

static int airspy_set_mixer_gain(struct airspy *s)
{
	int ret;
	u8 u8tmp;

	dev_dbg(s->dev, "mixer auto=%d->%d val=%d->%d\n",
			s->mixer_gain_auto->cur.val, s->mixer_gain_auto->val,
			s->mixer_gain->cur.val, s->mixer_gain->val);

	ret = airspy_ctrl_msg(s, CMD_SET_MIXER_AGC, 0, s->mixer_gain_auto->val,
			&u8tmp, 1);
	if (ret)
		goto err;

	if (s->mixer_gain_auto->val == false) {
		ret = airspy_ctrl_msg(s, CMD_SET_MIXER_GAIN, 0,
				s->mixer_gain->val, &u8tmp, 1);
		if (ret)
			goto err;
	}
err:
	if (ret)
		dev_dbg(s->dev, "failed=%d\n", ret);

	return ret;
}

These could become something like:

static int airspy_set_mixer_gain(struct airspy *s)
{
	int ret;
	u8 u8tmp;

	dev_dbg(s->dev, "mixer auto=%d->%d val=%d->%d\n",
			s->mixer_gain_auto->cur.val, s->mixer_gain_auto->val,
			s->mixer_gain->cur.val, s->mixer_gain->val);

	ret = airspy_ctrl_msg(s, CMD_SET_MIXER_AGC, 0, s->mixer_gain_auto->val,
			&u8tmp, 1);
	if (ret)
		goto err;

	if (s->mixer_gain_auto->val == false) {
		ret = airspy_ctrl_msg(s, CMD_SET_MIXER_GAIN, 0,
				s->mixer_gain->val, &u8tmp, 1);
		if (ret)
			goto err;
	}

	return 0;

err:
	dev_dbg(s->dev, "failed=%d\n", ret);
	return ret;
}


