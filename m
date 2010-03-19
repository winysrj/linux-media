Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33447 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab0CSRRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 13:17:21 -0400
Received: by bwz1 with SMTP id 1so232770bwz.21
        for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 10:17:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100319181333.3352a029@hermes>
References: <20100319180129.6fb65141@hermes>
	 <829197381003191007r1055f3dbo58d7712cff7cf19b@mail.gmail.com>
	 <20100319181333.3352a029@hermes>
Date: Fri, 19 Mar 2010 13:17:20 -0400
Message-ID: <829197381003191017k5adab45ejee5179bc66880cac@mail.gmail.com>
Subject: Re: em28xx - Your board has no unique USB ID and thus need a hint to
	be detected
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steffen Pankratz <kratz00@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 19, 2010 at 1:13 PM, Steffen Pankratz <kratz00@gmx.de> wrote:
> On Fri, 19 Mar 2010 13:07:23 -0400
> Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>
>> On Fri, Mar 19, 2010 at 1:01 PM, Steffen Pankratz <kratz00@gmx.de> wrote:
>> > Hi,
>> >
>> > this USB stick is a Pinnacle Pctv Hybrid Pro 320e device
>> > (ID eb1a:2881 eMPIA Technology, Inc.).
>> >
>> > Is there anything else you need to know?
>> <snip>
>>
>> This was fixed some time ago.  Just install the current v4l-dvb code
>> (instructions can be found at http://linuxtv.org/repo)
>
> This is what I did.
>
> hg tip output:
>
> changeset:   14494:929298149eba
> tag:         tip
> user:        Douglas Schilling Landgraf <dougsland@redhat.com>
> date:        Thu Mar 18 23:47:27 2010 -0300
> summary:     ir-keytable: fix prototype for kernels < 2.6.22

Hmm...  Interesting.  Your eeprom hash is different than everybody
else who has a 320e.  I will have to do a manual comparison and see
why it is different.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
