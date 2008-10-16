Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G6ke2V004318
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:46:40 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G6kW2r031775
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 02:46:32 -0400
Received: by wf-out-1314.google.com with SMTP id 25so3044736wfc.6
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 23:46:32 -0700 (PDT)
Message-ID: <aec7e5c30810152346q251c963h7a4419fa59fb6612@mail.gmail.com>
Date: Thu, 16 Oct 2008 15:46:31 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Robert Jarzmik" <robert.jarzmik@free.fr>
In-Reply-To: <8763ntf3o8.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <uskqyqg58.wl%morimoto.kuninori@renesas.com>
	<Pine.LNX.4.64.0810160041250.8535@axis700.grange>
	<aec7e5c30810151921v53ab947aq8e1dd6c6ee834eaa@mail.gmail.com>
	<Pine.LNX.4.64.0810160814190.3892@axis700.grange>
	<8763ntf3o8.fsf@free.fr>
Cc: V4L <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Add ov772x driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, Oct 16, 2008 at 3:35 PM, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>
>> Hm, so, to test your camera you have to modify your source and rebuild
>> your kernel... And same again to switch back to normal operation. Does not
>> sound very convenient to me. OTOH, making it a module parameter makes it
>> much easier. In fact, maybe it would be a good idea to add a new
>> camera-class control for this mode. Yet another possibility is to enable
>> debug register-access in the driver and use that to manually set the test
>> mode from user-space. A new v4l-control seems best to me, not sure what
>> others will say about this. As you probably know, many other cameras also
>> have this "test pattern" mode, some even several of them. So, this becomes
>> a control with a parameter then.
>
> Personnaly I'm rather inclined for the debug registers solutions.
>
> When developping a camera driver, the test pattern alone is not enough. You have
> to tweak the registers, see if the specification is correct, then understand the
> specification, and then change your driver code. My experience tells me you
> never understand correctly are camera setup from the first time.

One thing is when people write their driver, but the scenario that I'm
thinking about is more when people take an already existing soc_camera
sensor driver and hook it up to some soc_camera host. There are all
sorts of endian and swapping issues that need to be worked out. They
depend on soc_camera host driver, endian setting and userspace. Having
a test pattern available would surely help there in my opinion.

> So IMHO the registers are enough here.
>
>> Then a new control or raw register access would be a better way, I think.
> So do I.

I dislike the register access option since it requires the developer
to have some user space tool that most likely won't ship with the
kernel. I think seeing it as yet another video input source is pretty
clean. Or maybe it isn't very useful at all, I'm not sure. =)

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
