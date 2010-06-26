Return-path: <linux-media-owner@vger.kernel.org>
Received: from kelvin.aketzu.net ([81.22.244.161]:47704 "EHLO
	kelvin.aketzu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0FZSSR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 14:18:17 -0400
Date: Sat, 26 Jun 2010 21:12:17 +0300
From: Anssi Kolehmainen <anssi@aketzu.net>
To: linux-media@vger.kernel.org
Subject: HLCI support for VDR
Message-ID: <20100626181217.GA1386@aketzu.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I was wondering are there any plans to add HLCI (High-level CI) support to
VDR. Currently it only supports LLCI (Link-level CI) and therefore is unusable
with my FireDTV card.

I tried MythTV and it has implemented both HLCI and LLCI. It works just fine
so it might be somewhat easy to cut'n'paste the code (at least if you know
what the whole CI thing does).

[Actually the mythtv dvbci.cpp has copyright notice on top claiming it to be
from vdr :) ]

-- 
Anssi Kolehmainen
anssi.kolehmainen@iki.fi
040-5085390
