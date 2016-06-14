Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:52987 "EHLO
	avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbcFNSjB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 14:39:01 -0400
To: linux-media@vger.kernel.org
From: Nick Whitehead <nick@mistoffolees.me.uk>
Subject: EIT off-air tables for HD in UK
Message-ID: <57604D76.30705@mistoffolees.me.uk>
Date: Tue, 14 Jun 2016 19:31:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've just started to use this to recover EIT information from the 
transmitted stream (UK, freeview).

I've managed to get the tables OK, but the EIT name / description for 
all HD channels is scrambled. Some research indicates these are huffman 
encoded for an unclear reason.

Given the right tables, it should be possible therefore to decode them 
when they appear in the linked list of descriptors in each event. 
However, it appears that dvb_parse_string() called all the way down from 
dvb_read_sections() converts the character sets name / description 
strings so that they can no longer be decoded. If huffman encoded, I 
think the first character of each is a 0x1f, followed by a 0x01 or 0x02 
which probably indicates the table to use.

It seems to me therefore that the 0x1f needs to be picked up in the 
switch (*src) {} at line 395 in parse_string.c, and huffman decode done 
there. After the return from dvb_parse_string(), and certainly when they 
appear in the EIT table, it's too late.

I am not sure if I'm right about all this as I know very little about 
DVB. However it looks like that to me. Have I got this right or is 
already successfully handled somewhere I haven't realised?

