Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:50379 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754223Ab3CGEEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 23:04:12 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-class: urn:content-classes:message
Subject: Pixel Formats
Date: Wed, 6 Mar 2013 19:59:05 -0800
Message-ID: <B4589F7BF62FDC409F64E48C95EC0572113A6BFC@sjcaex01.aptad.aptina.com>
From: "Christian Rhodin" <Crhodin@aptina.com>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm looking for some guidance on the correct way to handle a new pixel
format.  What I'm dealing with is a CMOS image sensor that supports
dynamic switching between linear and iHDR modes.  iHDR stands for
"interlaced High Dynamic Range" and is a mode where odd and even lines
have different exposure times, typically with an 8:1 ratio.  When I
started implementing a driver for this sensor I used
"V4L2_MBUS_FMT_SGRBG10_1X10" as the format for the linear mode and
defined a new format "V4L2_MBUS_FMT_SGRBG10_IHDR_1X10" for the iHDR
mode.  I used the format to control which mode I put the sensor in.  But
now I'm having trouble switching modes without reinitializing the
sensor.  Does anyone (everyone?) have an opinion about the correct way
to implement this?  I'm thinking that the format is overloaded because
it represents both the size and type of the data.  Should I use a single
format and add a control to switch the mode?


Chris Rhodin
Aptina Imaging
Aptina, LLC / 3080 North First Street, San Jose, CA 95134

This e-mail and any attachments contain confidential information and are solely for the review and use of the intended recipient. If you have received this e-mail in error, please notify the sender and destroy this e-mail and any copies.


