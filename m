Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:65489 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab0AXVbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 16:31:35 -0500
Message-ID: <4B5CBC31.5090701@freemail.hu>
Date: Sun, 24 Jan 2010 22:31:29 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: git problem with uvcvideo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to fetch the uvcvideo from http://linuxtv.org/git/?p=pinchartl/uvcvideo.git;a=summary .
I tryied to follow the instructions but at the third step I get fatal error messages:

> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb
> Initialized empty Git repository in /usr/src/linuxtv.org/pinchartl/uvcvideo/v4l-dvb/.git/
> remote: Counting objects: 1455151, done.
> remote: Compressing objects: 100% (233826/233826), done.
> remote: Total 1455151 (delta 1210384), reused 1455044 (delta 1210312)
> Receiving objects: 100% (1455151/1455151), 317.25 MiB | 224 KiB/s, done.
> Resolving deltas: 100% (1210384/1210384), done.
> Checking out files: 100% (31566/31566), done.
> $ cd v4l-dvb/
> v4l-dvb$ git remote add uvcvideo http://linuxtv.org/git//pinchartl/uvcvideo.git
> v4l-dvb$ git remote update
> Updating origin
> Updating uvcvideo
> fatal: http://linuxtv.org/git//pinchartl/uvcvideo.git/info/refs not found: did you run git update-server-info on the server?
> error: Could not fetch uvcvideo

I also tried with the git:// link:

> v4l-dvb$ git remote rm uvcvideo
> v4l-dvb$ git remote add uvcvideo git://linuxtv.org//pinchartl/uvcvideo.git
> v4l-dvb$ git remote update
> Updating origin
> Updating uvcvideo
> fatal: The remote end hung up unexpectedly
> error: Could not fetch uvcvideo

Am I doing something wrong?

Regards,

	Márton Németh
