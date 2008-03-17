Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Mon, 17 Mar 2008 13:27:30 -0500
Message-ID: <C82A808D35A16542ACB16AF56367E0580A7968FF@exchange01.nsighttel.com>
In-Reply-To: <47DEB5EF.8010207@linuxtv.org>
References: <C82A808D35A16542ACB16AF56367E0580A7968E9@exchange01.nsighttel.com>
	<c70a981c0803170530w711784f3me773ae49dd876e3d@mail.gmail.com>
	<c70a981c0803170531jdbe8396j41ecd8394b97b5bb@mail.gmail.com>
	<c70a981c0803170701k3ab93c60k6a59414ce8807398@mail.gmail.com>
	<47DE9362.4050706@linuxtv.org>
	<C82A808D35A16542ACB16AF56367E0580A7968FE@exchange01.nsighttel.com>
	<47DEB5EF.8010207@linuxtv.org>
From: "Mark A Jenks" <Mark.Jenks@nsighttel.com>
To: "Steven Toth" <stoth@linuxtv.org>,
	"linux-dvb" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints kernel.
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

I'm compiling 2.4.24 right now to test it.

I've been running this box for over a year with a TV2000 card without
issues.  I was just trying to upgrade into DTV.

So, I really don't think it's a memory issue.

The TV2000 was a pci, this is my first pcie card I'm using in this box.

-Mark 

-----Original Message-----
From: Steven Toth [mailto:stoth@linuxtv.org] 
Sent: Monday, March 17, 2008 1:18 PM
To: Mark A Jenks; linux-dvb
Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints kernel.

CC'ing the mailing list back in.

Mark A Jenks wrote:
> Do you think I should push the kernel to 2.6.25? 

I maintain the driver on ubuntu 7.10, which I think has is 2.6.22-14 - 
or close to.

I have another AMD system at home that the driver completely freezes on,

no idea why, total system lockup. I don't trust the PCIe chipset on it, 
it's an early chipset and a little flakey.

Other than that the driver's been pretty reliable.

Lots of noise recently on the mailing lists about video_buf related 
issues and potential race conditions.

Try running the system with a single cpu core and report back, also, 
just for the hell of it, run memtest also.

- Steve




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
