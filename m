Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f200.google.com ([209.85.216.200]:46535 "EHLO
	mail-px0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZFHORa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 10:17:30 -0400
Received: by pxi38 with SMTP id 38so87168pxi.33
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2009 07:17:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A2D1CAA.2090500@kernellabs.com>
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com>
Date: Mon, 8 Jun 2009 10:17:32 -0400
Message-ID: <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: David Ward <david.ward@gatech.edu>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 8, 2009 at 10:14 AM, Steven Toth <stoth@kernellabs.com> wrote:
>> Please let me know how I should proceed in solving this.  I would be happy
>> to provide samples of captured video, results from new tests, etc.
>
> When you tune using azap, and you can see UNC and BER values, what is the
> SNR value and does it move over the course of 30 seconds?
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com

Also, I believe UNC and BER display garbage when signal lock is lost,
so do you see the "status" field change when the BER/UNC fields show
data?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
