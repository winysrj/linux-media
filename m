Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f190.google.com ([209.85.221.190]:35718 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbZFISz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 14:55:58 -0400
Received: by qyk28 with SMTP id 28so295131qyk.33
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2009 11:55:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A2EAF56.2090508@gatech.edu>
References: <4A2CE866.4010602@gatech.edu> <4A2D3A40.8090307@gatech.edu>
	 <4A2D3CE2.7090307@kernellabs.com> <4A2D4778.4090505@gatech.edu>
	 <4A2D7277.7080400@kernellabs.com>
	 <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
	 <4A2E6FDD.5000602@kernellabs.com>
	 <829197380906090723t434eef6dje1eb8a781babd5c7@mail.gmail.com>
	 <4A2E70A3.7070002@kernellabs.com> <4A2EAF56.2090508@gatech.edu>
Date: Tue, 9 Jun 2009 14:55:58 -0400
Message-ID: <829197380906091155u43319c82i548a9f08928d3826@mail.gmail.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Ward <david.ward@gatech.edu>
Cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 9, 2009 at 2:52 PM, David Ward <david.ward@gatech.edu> wrote:
> On 06/09/2009 10:24 AM, Steven Toth wrote:
>>
>> David has called out Comcast to review his installation.
>
> After replacing all the connectors and some cables from the pole all the way
> to the outlet, their meter ultimately showed 39-40dB at the outlet.  My card
> is showing the same SNR values as before.  Go figure.
>

I want to say that the SNR counter for the s5h1409 caps out at 30dB,
but I would have to double check the source code.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
