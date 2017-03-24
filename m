Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55867
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751562AbdCXKVM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 06:21:12 -0400
Date: Fri, 24 Mar 2017 07:21:04 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: peter@easthope.ca
Cc: linux-media@vger.kernel.org
Subject: Re: JVC camera and Hauppauge PVR-150 framegrabber.
Message-ID: <20170324072052.74cbf218@vento.lan>
In-Reply-To: <E1crCiL-0001oB-BQ@dalton.invalid>
References: <E1crCiL-0001oB-BQ@dalton.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 23 Mar 2017 17:04:21 -0700
peter@easthope.ca escreveu:

> With a manual setting of the device path and ID, the V4L2 Test Bench 
> produced this image from a JVC TK-1070U camera on a microscope.  
> http://easthope.ca/JVCtoPVR150screen.jpg
> 
> Setting the device in the Test Bench each time it is opened becomes 
> tedious and no /etc/*v4l* exists.  Can the default configuration be 
> adjusted permanently without recompiling?  How?
> 
> Although too dark, the image from the microscope slide is faintly 
> visible. The upper half of the image is on the bottom of the screen 
> and the lower half is at the top.  On a VCR I might try adjusting 
> vertical sync.  Is there an equivalent in the Test Bench?

You could use v4l2-ctl to set all parameters you need in order to
get a good quality image.

It is possible to automatically call it by adding a udev rule.
This link explains how to do things like that (although their
examples are for different use cases):

	https://www.mythtv.org/wiki/Device_Filenames_and_udev

Some of examples have a directive like:
	PROGRAM="..."

With basically makes udev to run a program or script when the device
gets detected.


Thanks,
Mauro
