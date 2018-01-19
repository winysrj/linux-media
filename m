Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38640 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753841AbeASN7Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 08:59:25 -0500
Received: by mail-wm0-f51.google.com with SMTP id 141so3713983wme.3
        for <linux-media@vger.kernel.org>; Fri, 19 Jan 2018 05:59:24 -0800 (PST)
Subject: SAA716x DVB driver
To: Jemma Denson <jdenson@gmail.com>, Soeren Moch <smoch@web.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Luis Alves <ljalvs@gmail.com>, linux-media@vger.kernel.org
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
 <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
 <20170827073040.6e96d79a@vento.lan>
 <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
 <20170909181123.392cfbb0@vento.lan>
 <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
 <20170916125042.78c4abad@recife.lan>
 <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
 <7c17c0a1-1c98-1272-8430-4a194b658872@gmail.com>
 <20171127092408.20de0fe0@vento.lan>
 <e2076533-5c33-f3be-b438-a1616f743a92@gmail.com>
 <20171202174922.34a6f9b9@vento.lan>
 <ce4f25e6-7d75-2391-d685-35b50a0639bb@web.de>
 <335e279e-d498-135f-8077-770c77cf353b@gmail.com>
From: =?UTF-8?Q?Tycho_L=c3=bcrsen?= <tycholursen@gmail.com>
Message-ID: <5070ebf3-79a9-571e-d56c-cee41b51f191@gmail.com>
Date: Fri, 19 Jan 2018 14:59:22 +0100
MIME-Version: 1.0
In-Reply-To: <335e279e-d498-135f-8077-770c77cf353b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jemma,

I'm with you: let's get merged at least something!

Did you find  a maintainer for this driver?
I can do simple stuff like in my fork of Soeren Moch's repo, but thats 
where it ends. I dont have the knowledge needed to maintain a driver.

I think that your proposal to use a stripped version of Luis Alves repo 
is a no go, since it contains a couple of demod/tuner drivers that are 
not upstreamed yet. That complicates the upstreaming process too much, I 
think.

I used a stripped version of Soeren Moch's repo to prove its stability 
instead, adding the drivers I need so I can test it. You can see what I 
did at : https://github.com/bas-t/linux-saa716x/commits/for-media-stripped

This has been tested with linux 4.9.77, 4.14.14 and 4.15-rc8.
Works like a charm for me.
