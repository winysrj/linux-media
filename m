Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:36700 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752265AbdLKQFX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 11:05:23 -0500
Subject: Re: [PATCH v2 5/6] [media] cxusb: implement Medion MD95700 digital /
 analog coexistence
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <f80a8f9e-f142-086e-9160-aea829eac9dc@maciej.szmigiero.name>
 <20171211134501.4a7270ec@vento.lan>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <16d5b34d-2910-6359-9f44-42a812d8d028@maciej.szmigiero.name>
Date: Mon, 11 Dec 2017 16:48:02 +0100
MIME-Version: 1.0
In-Reply-To: <20171211134501.4a7270ec@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11.12.2017 16:45, Mauro Carvalho Chehab wrote:
> Em Tue, 10 Oct 2017 23:36:55 +0200
> "Maciej S. Szmigiero" <mail@maciej.szmigiero.name> escreveu:
> 
>> This patch prepares cxusb driver for supporting the analog part of
>> Medion 95700 (previously only the digital - DVB - mode was supported).
>>
>> Specifically, it adds support for:
>> * switching the device between analog and digital modes of operation,
>> * enforcing that only one mode is active at the same time due to hardware
>> limitations.
>>
>> Actual implementation of the analog mode will be provided by the next
>> commit.
>>
>> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> 
> This patch doesn't apply:
> 
> Hunk #2 FAILED at 25.
> Hunk #3 FAILED at 47.
(..)

Probably it has already bit-rotted since October - will try to
respin within two weeks (while addressing your comments to patch 1,
too.)

Maciej
