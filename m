Return-path: <linux-media-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:54808 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3ATLki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 06:40:38 -0500
Received: from cpec03f0ed08c7f-cm001ac318e826.cpe.net.cable.rogers.com ([174.115.5.73]:54861 helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.80)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1TwsES-0003ob-Ay
	for linux-media@vger.kernel.org; Sun, 20 Jan 2013 05:34:32 -0500
Date: Sun, 20 Jan 2013 05:34:28 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-media@vger.kernel.org
Subject: several media-related tracked DocBook pdf files are ignored
Message-ID: <alpine.DEB.2.02.1301200533010.12772@oneiric>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


$ git ls-files -i --exclude-standard
Documentation/DocBook/media/dvb/dvbstb.pdf
Documentation/DocBook/media/v4l/crop.pdf
Documentation/DocBook/media/v4l/fieldseq_bt.pdf
Documentation/DocBook/media/v4l/fieldseq_tb.pdf
Documentation/DocBook/media/v4l/pipeline.pdf
Documentation/DocBook/media/v4l/vbi_525.pdf
Documentation/DocBook/media/v4l/vbi_625.pdf
Documentation/DocBook/media/v4l/vbi_hsync.pdf
arch/sh/boot/compressed/vmlinux.scr
arch/sh/boot/romimage/vmlinux.scr
$

  not sure if that's the effect you were going for.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
