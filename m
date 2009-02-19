Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:38244 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbZBSMU1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 07:20:27 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by smtp4-g21.free.fr (Postfix) with ESMTP id BBB834C8195
	for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 13:20:21 +0100 (CET)
Received: from localhost (lns-bzn-33-82-252-42-42.adsl.proxad.net [82.252.42.42])
	by smtp4-g21.free.fr (Postfix) with ESMTP id B568E4C802E
	for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 13:20:18 +0100 (CET)
Date: Thu, 19 Feb 2009 13:17:45 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media <linux-media@vger.kernel.org>
Subject: Questions about VIDIOC_G_JPEGCOMP / VIDIOC_S_JPEGCOMP
Message-ID: <20090219131745.455df4da@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The VIDIOC_G_JPEGCOMP / VIDIOC_S_JPEGCOMP v4l2 ioctls seem not to be
used by many drivers / applications. They should!

In some ms-win traces, there are automatic and dynamic adjustments of
the JPEG quality according to... who knows?

Also, most webcams do not include the quantization tables in the images.
Then, (in gspca), these tables are added by the subdrivers with a
quality defined by the testers and according to their taste.

As I understand, the JPEGCOMP ioctls permit to set the JPEG quality and
to define the content of the JPEG frames.

If I implement these controls in gspca:

- by default, I could not add the quantization and Huffman tables in the
  image frames,

- the quality could be set dynamically, this value being used to load
  the quantization tables in the webcam and also to convert the images.

The questions are:

1) May the driver refuse to set some values on VIDIOC_S_JPEGCOMP?
   For example, if it cannot add the Huffman table in the frames.

2) Will the VIDIOC_G_JPEGCOMP ioctl be used by the v4l library (for
   conversion purpose)?

3) Does anybody know a command line or X application which may get/set
   these JPEG parameters?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
