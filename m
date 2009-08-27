Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52072 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZH0Vn4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 17:43:56 -0400
Date: Thu, 27 Aug 2009 23:43:40 +0200
To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
From: semiRocket <semirocket@gmail.com>
Cc: "Linux Input" <linux-input@vger.kernel.org>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-2
Message-ID: <op.uzcbwtd53xmt7q@crni>
MIME-Version: 1.0
References: <20090827045710.2d8a7010@pedra.chehab.org>
 <4A96BD05.1080205@googlemail.com>
In-Reply-To: <4A96BD05.1080205@googlemail.com>
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Aug 2009 19:06:13 +0200, Peter Brouwer
<pb.maillists@googlemail.com> wrote:

>> After years of analyzing the existing code and receiving/merging patches
>> related to IR, and taking a looking at the current scenario, it is  
>> clear to me
>> that something need to be done, in order to have some standard way to  
>> map and
>> to give precise key meanings for each used media keycode found on
>> include/linux/input.h.

<snip>

Hi all,

Some end user thoughts, perhaps unwelcome but here it goes :)

I think that standardization of buttons is really needed that application
programmers can relly on, for example I see this like following:

I think that specific MCE compatible buttons need to be implemented that
are specific on most todays remotes. And I imagine a Linux Media Center
that works out-of-the-box. I plug in my Linux supported card, point my
remote and press Media center button which runs media center application.
Because it's standard and that's applications programers implemeted it as
key that triggers their app. If press Videos button on my remote, the app
switches to videos directory, because it's standard, and most remotes have
it, etc.

http://www.spinics.net/lists/linux-media/msg07705.html

And thinking of that, I have configuring nothing, it's already configured
because of standardization of buttons. And, if some advanced user doesn't
like this behavior, he can always tamper configuration files to suite his
need.

Forgive me if I'm missing something, as I don't know how it all works
together, but I think you've figured out the point of the meaning :).

I also welcome this effort.

Cheers,
Samuel


-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/mail/
