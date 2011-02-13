Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab1BMVpX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 16:45:23 -0500
Message-ID: <4D5850EF.3040406@redhat.com>
Date: Sun, 13 Feb 2011 19:45:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steven Karatnyk <stevenkaratnyk@rogers.com>
CC: Linux-media <linux-media@vger.kernel.org>, alexdeucher@gmail.com
Subject: Re: [PATCH 0/8] Port xf86-video-v4l driver to V4L2 version 2
References: <4D582DBD.5020806@rogers.com>
In-Reply-To: <4D582DBD.5020806@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 13-02-2011 17:15, Steven Karatnyk escreveu:
> Note: I've added a news item to the main page regarding V4L1's removal from the kernel.  In addition, I've attempted to summarize what the video-v4l  module's purpose, as well as how to use it, by sewing together the info from a bunch of sources (such as Alex's, Mauro comments, etc etc)
> 
> - http://www.linuxtv.org/wiki/index.php/Main_Page
> - http://www.linuxtv.org/wiki/index.php/Xf86-video-v4l

Thank you for adding them to the wiki. The info there seems consistent.

Currently, just some PCI devices implement the V4L2 overlay support,
needed by the driver to work. I'll eventually implement other modes
like mmap and userptr one day, but what I want to do first is to make
it support the textured video. I'm not sure about the other apps, but
xawtv works fine with the v4l driver.

Cheers,
Mauro
