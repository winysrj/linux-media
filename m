Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:51473 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752565Ab1LLMqy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 07:46:54 -0500
Message-ID: <4EE5F7BB.4070306@seiner.com>
Date: Mon, 12 Dec 2011 04:46:51 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: cx231xx kernel oops
References: <4EDC25F1.4000909@seiner.com> <1323058527.12343.3.camel@palomino.walls.org> <4EDC4C84.2030904@seiner.com> <4EDC4E9B.40301@seiner.com> <4EDCB6D1.1060508@seiner.com> <1098bb19-5241-4be4-a916-657c0b599efd@email.android.com> <c0667c34eccf470314966c2426b00af4.squirrel@mail.seiner.com> <4EE55304.9090707@seiner.com> <0b3ac95d-1977-4e86-9337-9e1390d51b83@email.android.com>
In-Reply-To: <0b3ac95d-1977-4e86-9337-9e1390d51b83@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> 800 MB for 320x420 frames? It sounds like your app has gooned its requested buffer size.
>   

That's an understatement.  :-)

> <wild speculation>
> This might be due to endianess differences between MIPS abd x86 and your app only being written and tested on x86.
> </wild speculation>
>   

My speculation too.  I don't know where that number comes from; the same 
app works fine with the saa7115 driver if I switch frame grabbers.  I'll 
have to do some fiddling with the code to figure out where the problem 
lies.  It's some interaction between the app and the cx231xx driver.



> You still appear to USB stack problems, but not as severe (can't change device config to some bogus config).
>   

The requested buffer size is the result of multiplying max_pkt_size * 
max_packets and the rejected config shows a max_packet_size of 0, maybe 
ithere;'s a problem with either endianness or int size... ???  Something 
to follow up on.
> Regards,
> Andy
>
> !DSPAM:4ee5f4e4112206551461313!
>
>   


-- 
Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.
    Albert Einstein

