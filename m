Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:37025 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935375Ab0B1Stf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 13:49:35 -0500
Date: Sun, 28 Feb 2010 19:49:51 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org,
	Mosalam Ebrahimi <m.ebrahimi@ieee.org>,
	Max Thrun <bear24rw@gmail.com>
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
Message-ID: <20100228194951.1c1e26ce@tele>
In-Reply-To: <1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 27 Feb 2010 21:20:27 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> +static int sd_querymenu(struct gspca_dev *gspca_dev,
> +		struct v4l2_querymenu *menu)
> +{
> +	switch (menu->id) {
> +	case V4L2_CID_POWER_LINE_FREQUENCY:
> +		switch (menu->index) {
> +		case 0:         /*
> V4L2_CID_POWER_LINE_FREQUENCY_50HZ */
> +			strcpy((char *) menu->name, "50 Hz");
> +			return 0;
> +		case 1:         /*
> V4L2_CID_POWER_LINE_FREQUENCY_60HZ */
> +			strcpy((char *) menu->name, "60 Hz");
> +			return 0;
> +		}
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}

In videodev2.h, there is:

V4L2_CID_POWER_LINE_FREQUENCY_50HZ      = 1,
V4L2_CID_POWER_LINE_FREQUENCY_60HZ      = 2,

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
