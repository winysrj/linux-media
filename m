Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([216.205.24.107]:22314 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751205AbdISLen (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 07:34:43 -0400
Subject: Re: [PATCH v1] media: rc: Add driver for tango IR decoder
To: Mans Rullgard <mans@mansr.com>
CC: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
References: <e05783d3-012d-0798-9a54-ff42039e728d@sigmadesigns.com>
 <yw1xd16oyqas.fsf@mansr.com>
 <a898310b-3286-43cb-3c0e-4359239c49cf@sigmadesigns.com>
 <yw1x60cfyq7a.fsf@mansr.com>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Message-ID: <f0fd5679-5e24-c0fc-e22a-6a819028baad@sigmadesigns.com>
Date: Tue, 19 Sep 2017 13:34:38 +0200
MIME-Version: 1.0
In-Reply-To: <yw1x60cfyq7a.fsf@mansr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/09/2017 11:48, Måns Rullgård wrote:

> Did you test the NEC32 variant?  I don't have anything that produces
> such codes.

I don't have a NEC32 IR remote control either.

IIUC, NEC32 means 16-bit address and 16-bit command.

I checked the RTL with a HW engineer. The HW block translates the IR
pulses into logical 1s and 0s according to the protocol parameters,
stuffs the logical bits into a register, and fires an IRQ when there
are 32 bits available. The block doesn't care if the bits are significant
or just checksums (that is left up to software).

Regards.
