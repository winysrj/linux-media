Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:1565 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab0DPV1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 17:27:07 -0400
MIME-Version: 1.0
In-Reply-To: <20100416205638.GA2873@hardeman.nu>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
	 <20100415214620.14142.19939.stgit@localhost.localdomain>
	 <u2x1a297b361004151617gbd08bc10l4fa202ab8dcec306@mail.gmail.com>
	 <20100416205638.GA2873@hardeman.nu>
Date: Sat, 17 Apr 2010 01:27:05 +0400
Message-ID: <j2r1a297b361004161427q88bd9fa3hbf64a38662199712@mail.gmail.com>
Subject: Re: [PATCH 5/8] ir-core: convert mantis from ir-functions.c
From: Manu Abraham <abraham.manu@gmail.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 17, 2010 at 12:56 AM, David Härdeman <david@hardeman.nu> wrote:
> On Fri, Apr 16, 2010 at 03:17:35AM +0400, Manu Abraham wrote:
>> On Fri, Apr 16, 2010 at 1:46 AM, David Härdeman <david@hardeman.nu> wrote:
>> > Convert drivers/media/dvb/mantis/mantis_input.c to not use ir-functions.c
>> > (The driver is anyway not complete enough to actually use the subsystem yet).
>>
>> Huh ? I don't follow what you imply here ..
>>
>
> The mantis_input.c file seems to be a skeleton as far as I could
> tell...not actually in use yet. Or am I mistaken?

Only the input related parts of the IR stuff is there in
mantis_input.c, the hardware handling is done by mantis_uart.c/h.
There is a small bit which has not gone upstream yet, which is
pending;
http://jusst.de/hg/mantis-v4l-dvb/rev/ad8b00c9edc2
