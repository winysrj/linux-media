Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35979 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab2FDSBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 14:01:23 -0400
Received: by bkcji2 with SMTP id ji2so3855537bkc.19
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 11:01:22 -0700 (PDT)
Message-ID: <4FCCF7F1.8010205@googlemail.com>
Date: Mon, 04 Jun 2012 20:01:21 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Doing a new upstream / linuxtv.org xawtv3 release?
References: <4FCC94AA.3040205@redhat.com>
In-Reply-To: <4FCC94AA.3040205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 6/4/12 12:57 PM, Hans de Goede wrote:
> I've been doing a lot of work on xawtv3 lately, mostly on the radio app
> but also some on xawtv itself. I'm no done and IMHO it would be good
> to do a new upstream release to get all those changes out there.
> 
> So any comments / suggestions? Note "go for it" also is a valid
> comment :)

The Debian patch tracker contains four patches for xawtv:
http://patch-tracker.debian.org/package/xawtv/3.102-3

Three of them are already in the git tree, this one is not:
> http://patch-tracker.debian.org/patch/series/view/xawtv/3.102-3/mtt_only_in_linux

Could you please add it before the release?

Thanks,
Gregor
