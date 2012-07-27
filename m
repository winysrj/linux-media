Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4234 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2G0U52 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 16:57:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduard Vaks <eddie.vaks@clear.net.nz>
Subject: Re: does not compile on ubuntu 2.6.32-41-generic
Date: Fri, 27 Jul 2012 22:57:20 +0200
Cc: linux-media@vger.kernel.org
References: <5012B7E5.4010707@clear.net.nz>
In-Reply-To: <5012B7E5.4010707@clear.net.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207272257.20931.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri July 27 2012 17:46:45 Eduard Vaks wrote:
> it may be an old compiler I don't know
> also i can't seem to get a diff so i have included the whole file I 
> haven't tested it (well it works on my system but I don' even know if I 
> use that part of the code) but it is realativly minor.
> 
> I have just named the union that func and offset are contained in 
> because the initalizer did not work + other resulting changes:
> struct v4l2_ioctl_info {
>          unsigned int ioctl;
>          u32 flags;
>          const char * const name;
>          union {
>                  u32 offset;
>                  int (*func)(const struct v4l2_ioctl_ops *ops,
>                                  struct file *file, void *fh, void *p);
>          } u;
>          void (*debug)(const void *arg, bool write_only);
> };

A patch for this (similar to yours) is waiting to be merged:

http://patchwork.linuxtv.org/patch/13336/

Regards,

	Hans
