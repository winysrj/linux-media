Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KWIqC-0003EY-02
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 00:41:17 +0200
Received: by fg-out-1718.google.com with SMTP id e21so106448fga.25
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 15:41:12 -0700 (PDT)
Message-ID: <37219a840808211541u2e4721f9kfe1b04a9e1924251@mail.gmail.com>
Date: Thu, 21 Aug 2008 18:41:12 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0808212337070.21606@pub5.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <1219330331.15825.2.camel@dark> <48ADCC81.5000407@nafik.cz>
	<37219a840808211321k34590d38v7ada0fb9655e5dfe@mail.gmail.com>
	<412bdbff0808211325h64d454d5m3353d8756b9eb737@mail.gmail.com>
	<37219a840808211329j697556fcj760057bb1c7b58a8@mail.gmail.com>
	<alpine.LRH.1.10.0808212337070.21606@pub5.ifh.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 and analog broadcasting
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, Aug 21, 2008 at 5:38 PM, Patrick Boettcher
<patrick.boettcher@desy.de> wrote:
> Hi,
>
> On Thu, 21 Aug 2008, Michael Krufky wrote:
>>
>> Lets sync up when you get to that point -- I have a good chunk of code
>> written that will add analog support to the dvb-usb framework as an
>> optional additional adapter type.
>
> Wow wow wow. That sounds like music in my ears. Great direction!!!
>
> Patrick.


...just to clarify -- the "good chunk of code" is still just v4l2 API
glue.  I didnt do _any_ of the streaming stuff yet.

videobuf can work with usb devices now, but I'm not sure that its the
best direction to take, within dvb-usb.

Like I said before -- what I have is worth keeping, but its extremely
far from complete.

When I get into it next (probably next month -- its busy here now)
then I will do my best to clean it up and post the work-in-progress to
a mercurial repository.

I repeat -- this will just be for the sake of collaboration.  I don't
think this will be ready for users for a good long time :-/

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
