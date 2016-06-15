Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38301 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbcFOIKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 04:10:36 -0400
Received: by mail-wm0-f47.google.com with SMTP id m124so23573109wme.1
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2016 01:10:35 -0700 (PDT)
Subject: Re: EIT off-air tables for HD in UK
To: Nick Whitehead <nick@mistoffolees.me.uk>,
	linux-media@vger.kernel.org
References: <57604D76.30705@mistoffolees.me.uk>
From: Jemma Denson <jdenson@gmail.com>
Message-ID: <e943e6e6-b5eb-446a-6a8f-585dfee8353c@gmail.com>
Date: Wed, 15 Jun 2016 09:10:32 +0100
MIME-Version: 1.0
In-Reply-To: <57604D76.30705@mistoffolees.me.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/06/16 19:31, Nick Whitehead wrote:
> I've just started to use this to recover EIT information from the 
> transmitted stream (UK, freeview).
>
> I've managed to get the tables OK, but the EIT name / description for 
> all HD channels is scrambled. Some research indicates these are 
> huffman encoded for an unclear reason.
>
> Given the right tables, it should be possible therefore to decode them 
> when they appear in the linked list of descriptors in each event. 
> However, it appears that dvb_parse_string() called all the way down 
> from dvb_read_sections() converts the character sets name / 
> description strings so that they can no longer be decoded. If huffman 
> encoded, I think the first character of each is a 0x1f, followed by a 
> 0x01 or 0x02 which probably indicates the table to use.
>
> It seems to me therefore that the 0x1f needs to be picked up in the 
> switch (*src) {} at line 395 in parse_string.c, and huffman decode 
> done there. After the return from dvb_parse_string(), and certainly 
> when they appear in the EIT table, it's too late.
>
> I am not sure if I'm right about all this as I know very little about 
> DVB. However it looks like that to me. Have I got this right or is 
> already successfully handled somewhere I haven't realised?
>
>

FYI mythtv decodes the EIT successfully so is probably a good place to 
start looking. The original patch to add it in is here: 
https://svn.mythtv.org/trac/attachment/ticket/5365/freesat_epg.diff
AFAIK Freeview HD is done the same way as Freesat.

Jemma.


