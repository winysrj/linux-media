Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43795 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab0BXPvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 10:51:13 -0500
Received: by bwz1 with SMTP id 1so2023162bwz.21
        for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 07:51:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8546ED.2060505@ip-minds.de>
References: <4B8544B3.4060902@ip-minds.de>
	 <829197381002240729g7ae87931w6454accf075c6c59@mail.gmail.com>
	 <4B8546ED.2060505@ip-minds.de>
Date: Wed, 24 Feb 2010 10:51:11 -0500
Message-ID: <829197381002240751n179daa56lf0bdc9080a387d90@mail.gmail.com>
Subject: Re: [linux-dvb] cx23885 / HVR 1200 - A/V Inputs?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jean-Michel Bruenn <jean.bruenn@ip-minds.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 24, 2010 at 10:34 AM, Jean-Michel Bruenn
<jean.bruenn@ip-minds.de> wrote:
> Hello Devin,
>
> thanks for your answer. Might i be able to help a bit? Whats missing?
>
> Cheers,
> Jean

Hi Jean,

At this point, what really needs to happen is a developer who is
familiar with the internals of the cx23885 (and has the datasheets)
needs to sit down and spend a few days debugging the driver.  I've
been too swamped with commercial projects to spend any real time on it
(although that's the sort of problem that would get solved faster if
some commercial party threw some money at the problem).  Since I'm
only really working on it in my free time, it's the sort of situation
where it'll start working "when I finally get around to it".

For what it's worth, most of the work I'm doing for the HVR-1800 is
common to the 1200/1250 as well in terms of the bugs I'm fixing would
be common to both.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
