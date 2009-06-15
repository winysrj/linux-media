Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:39965 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZFOJsI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 05:48:08 -0400
Date: Mon, 15 Jun 2009 11:48:05 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: dib3000mc.c and dib7000p.c compiler warnings
In-Reply-To: <200906141134.43101.hverkuil@xs4all.nl>
Message-ID: <alpine.LRH.1.10.0906151145570.23354@pub3.ifh.de>
References: <200906141134.43101.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
On Sun, 14 Jun 2009, Hans Verkuil wrote:

> Hi Patrick,
>
> The daily build reports these warnings for dib3000mc.c and dib7000p.c:
>
> /marune/build/v4l-dvb-master/v4l/dib3000mc.c: In
> function 'dib3000mc_i2c_enumeration':
> /marune/build/v4l-dvb-master/v4l/dib3000mc.c:863: warning: the frame size of
> 1508 bytes is larger than 1024 bytes
>
> /marune/build/v4l-dvb-master/v4l/dib7000p.c: In
> function 'dib7000p_i2c_enumeration':
> /marune/build/v4l-dvb-master/v4l/dib7000p.c:1341: warning: the frame size of
> 1568 bytes is larger than 1024 bytes
>
> In both cases a big state struct is allocated on the stack. Would it be
> possible to optimize that?

I agree that this is ugly and in fact I already have a solution for that. 
But it's not ready as a patch nor can it published :(.

I won't be able to work on it before mid-July. But then I will provide a 
solution.

thanks for raising this important problem,
Patrick.
