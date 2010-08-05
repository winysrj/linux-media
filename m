Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:45178 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756859Ab0HELSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 07:18:22 -0400
Date: Thu, 5 Aug 2010 13:19:19 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sudhindra Nayak <sudhindra.nayak@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Not able to capture video frames
Message-ID: <20100805131919.73541e9a@tele>
In-Reply-To: <AANLkTim5YmSsvhub3+t0_QX0k84xZgPy1FS5=9COfEzH@mail.gmail.com>
References: <AANLkTim5YmSsvhub3+t0_QX0k84xZgPy1FS5=9COfEzH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Aug 2010 11:34:28 +0530
Sudhindra Nayak <sudhindra.nayak@gmail.com> wrote:

> As you requested, I'm including the lsusb output below:

Hi Sudhindra,

The USB information indicate that the webcam uses uses isochronous
transfer. The driver ov534 you used as a base uses bulk transfer. So,
you must either remove the 'cam->bulk..' in sd_conf() or change your
base driver to ov519. In any case, don't forget to adjust the pkt_scan
function...

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
