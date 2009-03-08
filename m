Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:43998 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbZCHTUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 15:20:32 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: get_dvb_firmware after first review
Date: Sun, 8 Mar 2009 20:20:25 +0100
Cc: schollsky@arcor.de
References: <11673765.1236539194988.JavaMail.ngmail@webmail08.arcor-online.net>
In-Reply-To: <11673765.1236539194988.JavaMail.ngmail@webmail08.arcor-online.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903082020.26649.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sonntag, 8. März 2009, schollsky@arcor.de wrote:
> Hi all,
>
> I've browsed through the file and tried to get up to date download
> locations. The ones on linuxtv.org remain largely unchecked, I presume
> they're okay.

As I already said: Kudos, very nice that someone does this now.

>
> Comments at the right side are pretty much self-explanatory I hope. For two
> firmware files I could not find a valid download location, newer pages
> provide more recent versions here. What I did not check is wether the
> firmware is working or not - I plainly rely on correct filenames and proper
> checking routine insinde.
>
> Hope you find this useful by now.

At first a formal suggestion: Do send a unified diff instead of the file 
itself, this should show more easy what you did.

Second: The check routine uses the md5sum stored in $hash. And if checking is 
fine, you can be sure you got the exact same file, regardless of what you 
needed to change otherwise.

Regards
Matthias
