Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48736 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0JWLYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 07:24:17 -0400
Received: by gyg4 with SMTP id 4so1221925gyg.19
        for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 04:24:16 -0700 (PDT)
Message-ID: <4CC2C5D9.7080103@gmail.com>
Date: Sat, 23 Oct 2010 09:24:09 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	=?UTF-8?B?SGVybsOhbiBPcmRpYWxlcw==?= <h.ordiales@gmail.com>,
	"Igor M. Liplianin" <liplianin@me.by>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: V4L/DVB/IR patches pending merge
References: <4CC25F60.7050106@redhat.com>
In-Reply-To: <4CC25F60.7050106@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Ok, let me eat my own dogfood...

Em 23-10-2010 02:06, Mauro Carvalho Chehab escreveu:

> 		== Waiting for Mauro Carvalho Chehab <mchehab@redhat.com> fixes on Docbook == 
> 
> Feb,25 2010: DocBook/Makefile: Make it less verbose                                 http://patchwork.kernel.org/patch/82076   Mauro Carvalho Chehab <mchehab@redhat.com>

Patch broken, and not really important. Discarded.

> Feb,25 2010: DocBook/v4l/pixfmt.xml: Add missing formats for gspca cpia1 and sn9c20 http://patchwork.kernel.org/patch/82074   Mauro Carvalho Chehab <mchehab@redhat.com>

Patch applied.

> Feb,25 2010: v4l: document new Bayer and monochrome pixel formats                   http://patchwork.kernel.org/patch/82073   Mauro Carvalho Chehab <mchehab@redhat.com>

This patch were made by Guennadi. Not sure why Patchwork pointed it as me. It were depending on the auto-generate rules, due to some changes
that were needed to happen at some template files. I just applied those changes semi-manually, and finally applied the patch.

> Feb,25 2010: DocBook: Add rules to auto-generate some media docbooks                http://patchwork.kernel.org/patch/82075   Mauro Carvalho Chehab <mchehab@redhat.com>

This is actually the patch that auto-generate media-indices.tmpl and media-entities.tmpl. It needs
a more serious review, as some things are not working on it anymore, due to some API additions.
I'll postpone it, for now, until I have some time to fix. Eventually, I'll just discard, but I think
that some of the checks that happen here are important, as they help to track missing stuff at the API.

Cheers,
Mauro
