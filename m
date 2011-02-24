Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:33313 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab1BXJp2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 04:45:28 -0500
Message-ID: <4D6628AF.4040401@mm-sol.com>
Date: Thu, 24 Feb 2011 11:45:19 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
References: <cover.1298368924.git.svarbanov@mm-sol.com> <201102231630.43759.laurent.pinchart@ideasonboard.com> <201102231702.57636.hansverk@cisco.com> <201102231714.41770.laurent.pinchart@ideasonboard.com> <A24693684029E5489D1D202277BE894488C577A3@dlee02.ent.ti.com> <Pine.LNX.4.64.1102231729280.11581@axis700.grange> <A24693684029E5489D1D202277BE894488D6F9F5@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894488D6F9F5@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

<snip>
>> Sorry, I accept different opinions, and in the end only one of the two
>> possibilities will be implemented, and either way it'll all work in the
>> end, but, I don't buy either of these arguments.
> 
>> Complexity - the code is
>> already there, it is working, it is simple, it has not broken since it has
>> been implemented. I had it hard-coded in the beginning and I went over to
>> negotiation and never regretted it.
> 
> First of all, it seems that this discussion is heavily parallel i/f
> oriented, and soc_camera focused, and it's just not like that.
> 

yes, it seems that is correct. My patch just get back on host side some
sensor dynamic parameters and it doesn't pretending for any negotiation.

> Now, _just_ for soc_camera framework, yeah... it works and it's there, but
> still not providing a solution for other v4l2_subdev users (like Media
> Controller).
> 

I already start looking into soc_camera code, but I'm so confused. :(

> Complexity comes only when trying to make this truly generic, and avoid
> fragmentation of solutions (1 for soc, 1 for MC), plus adding support for
> serial (MIPI) interfaces
> 
> Now, also, the patch originally proposed by Stan doesn't actually deal with
> putting polarities as part of the interface parameters, which is something
> you're currently negotiating in soc_camera framework, again, just for
> parallel interfaces.
> 
> Now, just for the sake of clarifying my understanding, I guess what you're
> saying is to make sensor driver expose all possible polarities and physical
> details configurable, and make the platform data limit the actual options due to the physical layout.
> 
> For example, if in my board A, I have:
> 
> 	- OV5640 sensor driver, which supports both Parallel and CSI2
>         Interfaces (with up to 2 datalanes)
> 	- Rx subdev (or host) driver(s) which support Parallel, CSI2-A and
>         CSI2-B interfaces (with 2 and 1 datalanes respectively).
> 

If the sensor is physically connected as parallel and serial the board
code should dictates the preferred interface, IMO. Or ...

> I should specify in my boardfile integration details, such as the
> sensor is actually wired to the CSI2-B I/f, so make the sensor
> negotiate with the other side of the bus and enable CSI2 i/f with
> given details, like just use 1 datalane, and match datalane
> position/polarity.
> 
> Am I understanding right?
> 
>> Hardware damage - if this were the case, I'd probably be surrounded only
>> by bricks. How configuring a wrong hsync polarity can damage your
>> hardware?
> 
> Ok, I'll regret my statement on this one. I guess I was a bit too dramatic
> to point out consequences of HW mismatches. Nevermind this.
> 

:)

> Regards,
> Sergio
> 
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Best regards,
Stan
