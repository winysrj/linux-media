Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:51966 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZCFVIa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 16:08:30 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: pxa_camera and test bed
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 06 Mar 2009 22:08:19 +0100
Message-ID: <87d4cu4aws.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

You've asked me about how I was doing my tests.

Here there are :
 - git download: http://belgarath.falguerolles.org/git/v4l2-camera-tests.git/
 - browser :
 http://belgarath.falguerolles.org/gitweb/?p=v4l2-camera-tests.git;a=summary

You'll see all the bin/*.sh scripts, especially :
 - take_sample_images.sh to take a serie of images
 - compare_sample_images_to_refs.sh to compare to the reference images

That's a bit inspired from non-regression tests on communication stack I work
with at work, so no great creation here.

Have fun.

--
Robert
