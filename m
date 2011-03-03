Return-path: <mchehab@pedra>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:40372 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932084Ab1CCEx3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2011 23:53:29 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 3 Mar 2011 12:52:25 +0800
Subject: RE: isp or soc-camera for image co-processors
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DF0A71A63@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com>
 <201103011041.03424.laurent.pinchart@ideasonboard.com>
 <D5ECB3C7A6F99444980976A8C6D896384DEFA598FC@EAPEX1MAIL1.st.com>
 <201103011110.06258.laurent.pinchart@ideasonboard.com>
 <D5ECB3C7A6F99444980976A8C6D896384DEFA5998E@EAPEX1MAIL1.st.com>
 <4D6E2233.6090602@maxwell.research.nokia.com>
In-Reply-To: <4D6E2233.6090602@maxwell.research.nokia.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_D5ECB3C7A6F99444980976A8C6D896384DF0A71A63EAPEX1MAIL1st_"
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--_002_D5ECB3C7A6F99444980976A8C6D896384DF0A71A63EAPEX1MAIL1st_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Sakari, Laurent and Guennadi,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@maxwell.research.nokia.com]
> Sent: Wednesday, March 02, 2011 4:26 PM
> To: Bhupesh SHARMA
> Cc: Laurent Pinchart; Guennadi Liakhovetski; linux-
> media@vger.kernel.org
> Subject: Re: isp or soc-camera for image co-processors
>=20
> Hi Bhupesh and Laurent,
>=20
> Bhupesh SHARMA wrote:
> ...
> >> Try to configure your mailer to use spaces instead of tabs, or to
> make
> >> tabs 8
> >> spaces wide. It should then look good. Replies will usually mess the
> >> diagrams
> >> up though.
> >
> > Ok, I will try it :)
>=20
> Attachments are usually safe as well.

Please find attached a top level diagram of the system.
One thing to note here is that the soc itself has a camera
interface IP that supports ITU interface. As the co-processor
supports both ITU and CSI-2 interface, it should not be a problem
to connect the two via ITU interface.

> ...
>=20
> >>> Are there are reference drivers that I can use for my study?
> >>
> >> The OMAP3 ISP driver.
> >
> > Thanks, I will go through the same.
>=20
> The major difference in this to OMAP 3 is that the OMAP 3 does have
> access to host side memory but the co-processor doesn't --- as it's a
> CSI-2 link.
>=20
> Additional CSI-2 receiver (and a driver for it) is required on the host
> side. This receiver likely is not dependent on the co-processor so the
> driver shouldn't be either.
>=20
> For example, using this co-processor should well be possible with the
> OMAP 3 ISP, in theory at least. What would be needed in this case is...
> support for multiple complex Media device drivers under a single Media
> device --- both drivers would be accessible through the same media
> device.
>=20
> The co-processor would mostly look like a sensor for the OMAP 3 ISP
> driver. Its internal topology would be more complex, though.
>=20
> Just a few ideas; what do you think of this? :-)

Yes, but I think I need to explain the system design better :
One, there is an camera interface IP within the SOC as well which=20
has an internal buffer to store a line of image data and dma capabilities
to send this data to system ddr.

So, co-processor has no access to system MMU or buffers inside the main SoC=
,
but it has internal buffer to store data. It is connected via either a ITU =
or
CSI-2 interface to the SoC. This is the primary and major difference betwee=
n our
architecture and OMAP 3 ISP.

As I read more the OMAP 3 TRM, I wonder whether SoC framework fits better
in our case, as we have three separate entities to consider here:
	- Camera Host inside the SoC
	- Camera Co-processor connected with host via CSI-2/ITU (data interface)
	  and I2C/CCI (control interface)
	- Camera sensor connected to the co-processor via CSI-2 (data interface)
	  and I2C/CCI (control interface)
What are your views?
Guennadi can you also pitch in with your thoughts..

I fear that neither soc-camera  nor media framework have support
for 3 entities listed above, as of now.

> >>> Unfortunately the data-sheet of the co-processor cannot be made
> >> public
> >>> as of yet.
> >>
> >> Can you publish a block diagram of the co-processor internals ?
> >
> > I will check internally to see if I can send a block-diagram
> > of the co-processor internals to you. The internals seem similar to
>=20
> I'd be very interested in this as well, thank you.

I have raised a request internally to enquire about the same :)

> > OMAP ISP (which I can see from the public TRM). However, our
> > co-processor doesn't have the circular buffer and MMU that ISP seem
> to
> > have (and some other features).
> >
> > In the meantime I copy the features of the co-processor here for your
> review:
> >
> > Input / Output interfaces of co-processor:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > - Sensor interfaces: 2 x MIPI CSI-2 receivers (1 x dual-lane up to
> 1.6 Gbit/s
> >  and 1 x single lane up to 800 Mbit/s)
> > - Host interface: MIPI CSI-2 dual lane transmitter (up to 1.6 Gbit/s)
> or ITU
> >  (8-bit CCIR interface, up to 100 MHz) - all with independent
> variable
> >  transmitter clock (PLL)
> > - Control interface: CCI (up to 400 kHz) or SPI
> >
> > Sensor support:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > - Supports two MIPI compliant sensors of up to 8 Megapixel resolution
> >  (one sensor streaming at a time)
> > - Support for auto-focus (AF), extended depth of field (EDOF) and
> wide dynamic
> >  range (WDR)sensors
> >
> > Internal Features:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > - Versatile clock manager and internal buffer to accommodate a wide
> range of data rates
> >   between sensors and the coprocessor and between the coprocessor and
> the host.
> > - Synchronized flash gun control with red-eye reduction (pre-flash
> and main-flash strobes) for
> >   high-power LED or Xenon strobe light
>=20
> Does the co-processor have internal memory or can external memory be
> attached to it for buffer storage?
>=20

The co-processor has no access to system MMU or buffers inside the main SoC=
,
but it has internal buffer to store data.

Regards,
Bhupesh

--_002_D5ECB3C7A6F99444980976A8C6D896384DF0A71A63EAPEX1MAIL1st_
Content-Type: image/jpeg; name="connection_diagram.JPG"
Content-Description: connection_diagram.JPG
Content-Disposition: attachment; filename="connection_diagram.JPG";
	size=29878; creation-date="Thu, 03 Mar 2011 12:33:11 GMT";
	modification-date="Thu, 03 Mar 2011 12:33:11 GMT"
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a
HBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAFLAyEDASIA
AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD3+iii
gAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKA
CiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAK
KKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoo
ooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACs/+3dI/tb+yf7Vsf7S/58/tCed03fczu6c9
OlaFFAGf/bukf2t/ZP8Aatj/AGl/z5/aE87pu+5nd056dKP7d0j+1v7J/tWx/tL/AJ8/tCed03fc
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
MZzjPGay/Dl0+kSXGi3llf8A2t7+5mSZLWR4ZY5JWkVvNA2LgNghmByuMHIy9NTiPj+SP7LqODaL
biU6dOIt4dmI8zZsxg9c496besUuv+X+egnon5f5/wBM6ishfEunNrh0cLffbR1B0+48vH97zNmz
bxjOcZ4zWvXLpqcR8fyR/ZdRwbRbcSnTpxFvDsxHmbNmMHrnHvRf3ku/+QPZs6ioY7qGW4mt0fMs
G3zFwflyMj9K48aBGlymqjTmOprrJK3DRlpEhaQqwUnlYypJIGF5J6nNPg0TQNM8a3E0nhyFbm5e
OW1u4dKMgV8HeTKiERtnkliM5zk80k7qL7/5XFJ2k12/4K/Q7OivN7XTL3/hNDLemOG++3vIlymh
TySPBuJVPtiuY1QphdpAx6Zwx3LHwrZ3N/eahdwzLepqbT287ffiUFeI9wO1HAw23G4E/g07tJ/1
t/n+ASum1/XX/L8TXutb8jWY9Mt9OvLybYskzweWEt0Ziqs5d1JztbhQx+U8dM6tcbp/hqKH4iar
fn+1RF9ltXike/uTG8m+csuC+1gMr8hyFzwBnnIuVv7nxvFdJpEcNzDqCxtKmjymb7ODt3m8LBCj
A52KDgHB+6SKtqo9wk7Jy7f5f1+R6TRXH2Frp0fiq4k1fSJp9aa6drW/fTnmRYcfIEmCssQC5BUs
vzbjj5snHtdMvf8AhNDLemOG++3vIlymhTySPBuJVPtiuY1QphdpAx6ZwxS1t5jlom+3/BPSKKKK
ACiiigAooooAKpieM6y9v5C+YLdX87uQWI29OnGeverlZi/8jTL/ANeSf+htUN+9Fev5MOj/AK6o
06KKKsAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKpieM6y9v5C+YLdX
87uQWI29OnGeverlZi/8jTL/ANeSf+htUN+9Fev5MOj/AK6o06KKKsAooooAKKKKACiiigAooooA
KKKKACiiigAooooAKpieM6y9v5C+YLdX87uQWI29OnGeverlZi/8jTL/ANeSf+htUN+9Fev5MOj/
AK6o06KKKsAooooAKKKKACiiigAooooAKKKKACiiigAooooAKpieM6y9v5C+YLdX87uQWI29OnGe
verlZi/8jTL/ANeSf+htUN+9Fev5MOj/AK6o06KKKsAooooAKph7b+2XQRt9q+zqS/bZuOB165z2
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
g/dvfodPRWDHB9m8bsY57orc2TySRPcyPGGV0AKozFU4J+6BmmW/iSS58WT6KkVggg++s16UumG0
HekHl/MmSBu3469xihapef6Cvq12/wArnQ0UUUDCiiigAqmLSQay95lfLa3WLGechify5q5WYv8A
yNMv/Xkn/obVD+KPz/Jh0f8AXVGnRRRVgFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABVMWkg
1l7zK+W1usWM85DE/lzVysxf+Rpl/wCvJP8A0Nqh/FH5/kw6P+uqNOiiirAKKKKACiiigAooooAK
KKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAoo
ooAKKKKACqC28o197nZ+5NqsYbI+8GY4x16EVfrOWWT/AISSSLe3li0VtmeM725x61DtzR+f5MOj
/rqjRoooqwCiiigAooooAKKKKACiiigAooooAKKKKACiiigAoornluddPjF7E3mnf2csAuNgsn83
aWK7d/m4zkZzt/DvSvql3Dpc6GiuZW48SHxY1gdR0n7GsYucDTpPMMZcjZu8/G7A+9txn+HtUC+K
L0+GotS8q3859Z+wFdrbfL+2+Rnrndt564z2xxVQXOk11dvxt+YPT+vK51tFFFIAqgtvKNfe52fu
TarGGyPvBmOMdehFX6zllk/4SSSLe3li0VtmeM725x61DtzR+f5MOj/rqiq3h559QS4vda1G8gjm
8+OzlECxIwOV5SNXIU9AWPTnNaIsIhqrajufzmgEBXI27QxbPTrk1aoq7f1+AWMN/Cti8NpH51wo
tr575WDLlmaQyFD8v3NxBwMH5RzT7fw6lnqcl1aalfW9tLMZ5bBDH5LyHq3KF1yeSFYAnPHJzs0U
X6g9Xd/1/V2FY8ugG51eK+u9VvbiKCXzoLORYRFE+CAQVjD8Anqx685rYooAxD4fmPiFdXOu6llQ
UFrtt/K2EglP9VvxkDndn3rkrLw7rFn4uk1G302eK8lvnaW7ZLJrZrdpCSPMwbonZgAE4D4HCCvS
KKFpbyDv5madEtjCIt8u0Xn2zqM79+/HTpn8fes9fCFul8ZxqWoC2+2fblsg0YiWYtuLZCb2BOeG
YjngDAx0VFEfdtbp/wAD/JCave/X/g/5v7zEPh+Y+IV1c67qWVBQWu238rYSCU/1W/GQOd2feny6
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
9TFJP5/5ffsOWt7af0/8/wADmE1bU3Cawupysr6sbD+yxFGYwonMJOdgk3hQZCd2ODxjmu2qkNG0
tdVbVRptmNRZdpuxAvnEYxjfjOMcdau0+lge4UUUUAFZi/8AI0y/9eSf+htWnVMQRjWXuPPXzDbq
nk9wAxO7r05x07VDXvRfr+TDo/66ouUUUVYBRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAVmL
/wAjTL/15J/6G1adUxBGNZe489fMNuqeT3ADE7uvTnHTtUNe9F+v5MOj/rqi5RRRVgFFFFABRRRQ
AUUUUAFFFFABRRRQAUUUUAFFFFABWYv/ACNMv/Xkn/obVp1TEEY1l7jz18w26p5PcAMTu69OcdO1
Q170X6/kw6P+uqLlFFFWAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFF
FFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFZi/8AI0y/9eSf+htWnVMWkg1l7zK+
W1usWM85DE/lzUNe9F+v5MOj/rqjgtKnubrVpmsJdbl1RdamSVpnuTZLarOwYfOfJ4jGAE+YNjph
sdHBqXiO71Cd4Lax+w21+bZo8MZZo8qC4YsFQrknGG3AcbeM71nY22nxyR2sflpJK8zDcTl3Ysx5
9SSadb2sNr5vkpt82QyvyTlj1PNVG6tfovx0/DR/eOdpSbXV/hr/AJr7jlx4i1Q7NV32P9kPqP2A
WxibzwfO8jf5ocqfn527OnGc1o2N5q+qanPNDLZW+l29w9uYZLZ3nmKHDMH3qEG7IA2twM5+bAnj
8N6XFqh1FIJVmMhl2C4k8kSHq4i3eWGOSd23OSTnJp/9gaeNXOpxrcRXLNvcQ3csccjYxueJWCOc
YGWUngegpr+vw/4P3if9f19xz1v4vvrrX/Kgt5ZLIXjWZhXSbkkbXKGX7T/qsAgnbjp/Fniry63f
jxc1hdyxWVpv2QRy2EpN18mQUuQ/lg5z8hXdhD25rSXw/p6aqdRjF1FOW3skV5MkTtjBZolYIxPc
lTmgeH7D+1f7SY3ck4beqy3s0kStjGViZyin0woxQtLf1/X9eVh7tr+v6/rrfNXW78eLmsLuWKyt
N+yCOWwlJuvkyClyH8sHOfkK7sIe3NVx4i1Q7NV32P8AZD6j9gFsYm88HzvI3+aHKn5+duzpxnNb
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
8bunHXpQBoUVn/2FpH9rf2t/ZVj/AGl/z+fZ087pt+/jd0469KP7C0j+1v7W/sqx/tL/AJ/Ps6ed
02/fxu6cdelAGhRWf/YWkf2t/a39lWP9pf8AP59nTzum37+N3Tjr0o/sLSP7W/tb+yrH+0v+fz7O
nndNv38bunHXpQBoUVn/ANhaR/a39rf2VY/2l/z+fZ087pt+/jd0469KP7C0j+1v7W/sqx/tL/n8
+zp53Tb9/G7px16UAaFFZ/8AYWkf2t/a39lWP9pf8/n2dPO6bfv43dOOvSj+wtI/tb+1v7Ksf7S/
5/Ps6ed02/fxu6cdelAGhRWf/YWkf2t/a39lWP8AaX/P59nTzum37+N3Tjr0o/sLSP7W/tb+yrH+
0v8An8+zp53Tb9/G7px16UAaFFZ/9haR/a39rf2VY/2l/wA/n2dPO6bfv43dOOvSj+wtI/tb+1v7
Ksf7S/5/Ps6ed02/fxu6cdelAGhRWf8A2FpH9rf2t/ZVj/aX/P59nTzum37+N3Tjr0o/sLSP7W/t
b+yrH+0v+fz7OnndNv38bunHXpQBoUVn/wBhaR/a39rf2VY/2l/z+fZ087pt+/jd0469KP7C0j+1
v7W/sqx/tL/n8+zp53Tb9/G7px16UAaFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUU
UUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRR
QAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFA
BRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAF
FFFABRRRQB//2Q==

--_002_D5ECB3C7A6F99444980976A8C6D896384DF0A71A63EAPEX1MAIL1st_--
