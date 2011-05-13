Return-path: <mchehab@gaivota>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51890 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758469Ab1EMXX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 19:23:56 -0400
Received: by mail-yw0-f49.google.com with SMTP id 9so1386884ywf.8
        for <linux-media@vger.kernel.org>; Fri, 13 May 2011 16:23:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DCDB846.1010204@iki.fi>
References: <BANLkTi=RVE0zk83K0hn89H3S6CKEmKSj2A@mail.gmail.com> <4DCDB846.1010204@iki.fi>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Fri, 13 May 2011 18:23:34 -0500
Message-ID: <BANLkTikswdgo+z0dngcAXBiUH+8EgBEE3Q@mail.gmail.com>
Subject: Re: [ANNOUNCE] New OMAP4 V4L2 Camera Project started
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hansverk@cisco.com>, Rob Clark <rob@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, May 13, 2011 at 6:01 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Aguirre, Sergio wrote:
>> Hi all,
>
> Hi, Sergio!

Hi Sakari,

>
>> Just to let you know that I've just officially registered for a new
>> project in the Pandaboard.org portal for OMAP4 v4l2 camera support.
>>
>> You can find it here:
>>
>> http://omiio.org/content/omap4-v4l2-camera
>>
>> And also, you can find the actual Gitorious project with the code here:
>>
>> https://www.gitorious.org/omap4-v4l2-camera
>>
>> If anyone is interested in contributing for this project, please let
>> me know, so I can add you as a contributor to the project.
>
> I'm very, very happy to see a project to start implementing V4L2 support
> for the OMAP 4 ISS!! Thanks, Sergio!

I'm pretty excited about it too :) Thanks.

>
> A few comments:
>
>
> - The driver is using videobuf. I wonder if the driver would benefit
> more from videobuf2.
>

Sure, that's definitely one of the first targets. I'll migrate to it.

>
> - As far as I understand, the OMAP 4 ISS is partially similar to the
> OMAP 3 one in design --- it has a hardware pipeline, that is. Fitting
> the bus receivers and the ISP under an Media controller graph looks
> relatively straightforward. The same might apply to SIMCOP, but then the
> question is: what kind of interface should the SIMCOP have?

That's a big question :) And I'm yet not sure on that. I'll certainly need to
think about it, and probably start planning for RFCs.

BTW, this driver is just implementing a super simple CSI2-A Rx -> MEM
pipeline so far. I started with this because i wanted to avoid wasting my time
on developing somethign huge, and having to do heavy rework after reviews
take place.

>
> Being familiar with the history of the OMAP 3 ISP driver, I know this is
> not a small project. Still, starting to use the Media controller in an
> early phase would benefit the project in long run since the conversion
> can be avoided later.

Agreed.

>
>
> Which parts of the ISS require regular attention from the M3s? Is it the
> whole ISS or just the SIMCOP, for example?

In theory, the whole ISS, which includes SIMCOP, cna be driven from either
A9 or M3 cores.

Architecturally, it's better to keep the dedicated M3 cores for
driving ISS, and to
save some considerable cycles from A9. Problem is, we have to deal with IPC
communication channels, and that might make the driver much more complex
and requiring much more software layers to be in place for that.

The long term vision about this is that, it might be good ot see how easy is to
keep a Media Controller device, which sends the pipeline and subdevice
configuration
to M3 software, and just keep the Board specific and Usecases in A9 side.

Immediate problems are how to approach this with purely open source tools.
(As far as I know, it's so far only possible with TI proprietary compilers)

So, it might definitely take this discussion to a much more complex
level and more
complete analysis. Hopefully we can have a good discussion about the long term
future of this.

So far, I'm just starting with the simple stuff, ISS CSI2 Rx interface :)

Kiitos! Thanks for the interest.

Regards,
Sergio

>
> Kind regards,
> Sakari Ailus
>
> Ps. I have nothing against SoC camera, but when I look at the ISS
> overview diagram (section 8.1 in my TRM) I can't avoid thinking that
> this is exactly what the Media controller was created for. :-)

The main reason why it started as a soc_camera is because I started this
driver in a 2.6.35 android kernel, and refused to backport all the
Media Controller patches to it :)

But now being based in mainline, that's a different story. ;)

>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
>
