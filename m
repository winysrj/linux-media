Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbZKYRXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 12:23:13 -0500
Date: 25 Nov 2009 18:20:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: khc@pm.waw.pl
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDZb9P9ZjFB@christoph>
In-Reply-To: <m3fx827dgi.fsf@intrepid.localdomain>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

on 25 Nov 09 at 17:53, Krzysztof Halasa wrote:
> Jarod Wilson <jarod@wilsonet.com> writes:
[...]
>> nimble. If we can come up with a shiny new way that raw IR can be
>> passed out through an input device, I'm pretty sure lirc userspace can
>> be adapted to handle that.

As Trent already pointed out, adding support for raw IR through an input  
device would require a new interface too. You just put the label "input  
device" on it. This does not make much sense for me.

> Lirc can already handle input layer. Since both ways require userspace
> changes,

I'm not sure what two ways you are talking about. With the patches posted  
by Jarod, nothing has to be changed in userspace.
Everything works, no code needs to be written and tested, everybody is  
happy.

We had exactly the same discussion around one year ago. I've seen no new  
arguements in the current discussion and nobody came up with this shiny  
new way of integrating LIRC into the input layer since last year. Maybe  
it's about time to just accept that the LIRC interface is the way to go.

Can we finally get the patch integrated, please?

Christoph
