Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32801 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbbFIBEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 21:04:12 -0400
Received: by padev16 with SMTP id ev16so2884089pad.0
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2015 18:04:12 -0700 (PDT)
Message-ID: <55763B8D.4060107@igel.co.jp>
Date: Tue, 09 Jun 2015 10:04:13 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
MIME-Version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC] V4L2 codecs in user space
References: <em1e648821-484a-48b8-afe4-beed2241343a@damian-pc>	 <55751D44.6010102@igel.co.jp> <1433771439.480.2.camel@collabora.com>
In-Reply-To: <1433771439.480.2.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On 2015-06-08 10:50 PM, Nicolas Dufresne wrote:
> Le lundi 08 juin 2015 à 13:42 +0900, Damian Hobson-Garcia a écrit
> :
>> Also, if this method is not recommended, should there be a 1-2
>> line disclaimer on the "V4L2_Userspace_Library" wiki page that
>> mentions this?
> 
> I think you may have got that wrong. The V4L2 userspace library is
> not implementing any device drivers. It allow older software to
> work with latest V4L2 features by emulating what is possible. It
> also implement platform specific setups (media controller) and
> eventually will contain needed parsers that would otherwise
> represent a security threat if ran inside the Linux Kernel.
> 
Just to verify that we're on the same page, but it sounds to me that
what you're describing is the libv4l library, whereas what I was
originally referring to was the section under "A solution" at
http://linuxtv.org/wiki/index.php/V4L2_Userspace_Library
that talks about a FUSE interface to a daemon running in a different
process.  Or perhaps we're both talking about the same thing.  That
page also seems to mention that something like libv4l would be the
ideal solution, but that it does not exist (it's an old page).

Thank you,
Damian


> Nicolas
> 
