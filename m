Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758288AbZLGXQD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 18:16:03 -0500
Message-ID: <4B1D8CB3.5070800@redhat.com>
Date: Mon, 07 Dec 2009 21:16:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@thalesgroup.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
References: <4B1D411F.309@thalesgroup.com>
In-Reply-To: <4B1D411F.309@thalesgroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Emmanuel Fusté wrote:
> Mauro Carvalho Chehab wrote:
> 
>> In summary,
>>
>> While the current EVIO[G|S]KEYCODE works sub-optimally for scancodes
>> up to 16 bytes
>> (since a read loop for 2^16 is not that expensive), the current approach
>> won't scale with bigger scancode spaces. So, it is needed expand it
>> to work with bigger scancode spaces, used by more recent IR protocols.
>>
>> I'm afraid that any tricks we may try to go around the current limits
>> to still
>> keep using the same ioctl definition will sooner or later cause big
>> headaches.
>> The better is to redesign it to allow using different scancode spaces.
>>
>>
>>   
> I second you: input layer events from drivers should be augmented with a
> protocol member,

Yeah, I added the protocol type info inside the internal representation of
the IR table. As I managed to do all the work inside one file (ir-keytable.c),
changing it to use arbitrary sized scancode lengths will be trivial (currently,
it is u16 just because just because it currently enough for the in-kernel drivers,
but this will be changed when integrating with lirc):

http://linuxtv.org/hg/v4l-dvb/rev/7b983cd30f0f

> allowing us to define new ioctl and new ways to
> efficiently store and manage sparse scancode spaces (tree, hashtable
> ....). It will allow us to abstract the scancode value and to use
> variable length scancode depending on the used protocol, and using the
> most appropriate scheme to store the scancode/keycode mapping per protocol.

True.

> The today scancode space will be the legacy one, the default if not
> specified "protocol". It will permit to progressively clean up the
> actual acceptable mess in the input layer and finally using real
> scancode -> keycode mappings everywhere if it is cleaner/convenient.

Yes. By purpose, I added IR_TYPE_UNKNOWN as 0. This way, all tables that don't
specify a protocol can be considered legacy.

Cheers,
Mauro.
