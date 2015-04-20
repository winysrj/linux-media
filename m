Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:35150 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbbDTLYm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 07:24:42 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: Linux Media <linux-media@vger.kernel.org>,
	"kernel-mentors\@selenic.com" <kernel-mentors@selenic.com>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"hans.verkuil" <hans.verkuil@cisco.com>
References: <CAM_ZknVRzewY23-ZGJrZxEmLa2k6DXyxb1pH-1dJ9tLV7VZ03w@mail.gmail.com>
Date: Mon, 20 Apr 2015 13:18:14 +0200
In-Reply-To: <CAM_ZknVRzewY23-ZGJrZxEmLa2k6DXyxb1pH-1dJ9tLV7VZ03w@mail.gmail.com>
	(Andrey Utkin's message of "Sun, 19 Apr 2015 10:36:09 +0300")
MIME-Version: 1.0
Message-ID: <m3oamjujyh.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: On register r/w macros/procedures of drivers/media/pci
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey.utkin@corp.bluecherry.net> writes:

> I am starting a work on driver for techwell tw5864 media grabber&encoder.

If this is tw6864 then I have a driver mostly completed.
Actually I'm using tw6869 but I think this is very similar (4 channels
instead of 8 and PCI instead of PCIe). I have 6864s but haven't yet
tried using them for trivial reasons.

This is BTW completely different chip (family) than the old tw68x.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
