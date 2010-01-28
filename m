Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56451 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751123Ab0A1Uxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 15:53:31 -0500
Date: Thu, 28 Jan 2010 21:52:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: match signedness of soc_camera_limit_side()
In-Reply-To: <4B60B32A.5090806@freemail.hu>
Message-ID: <Pine.LNX.4.64.1001282105200.8946@axis700.grange>
References: <4B5AFD11.6000907@freemail.hu> <Pine.LNX.4.64.1001271645440.5073@axis700.grange>
 <4B6081D4.5070501@freemail.hu> <Pine.LNX.4.64.1001271915400.5073@axis700.grange>
 <4B609AD4.605@freemail.hu> <Pine.LNX.4.64.1001272109470.5073@axis700.grange>
 <4B60B32A.5090806@freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 Jan 2010, Németh Márton wrote:

> Guennadi Liakhovetski wrote:
> > You didn't reply to my most important objection:
> > 
> > On Wed, 27 Jan 2010, Németh Márton wrote:
> > 
> >> diff -r 31eaa9423f98 linux/include/media/soc_camera.h
> >> --- a/linux/include/media/soc_camera.h	Mon Jan 25 15:04:15 2010 -0200
> >> +++ b/linux/include/media/soc_camera.h	Wed Jan 27 20:49:57 2010 +0100
> >> @@ -264,9 +264,8 @@
> >>  		common_flags;
> >>  }
> >>
> >> -static inline void soc_camera_limit_side(unsigned int *start,
> >> -		unsigned int *length, unsigned int start_min,
> >> -		unsigned int length_min, unsigned int length_max)
> >> +static inline void soc_camera_limit_side(int *start, int *length,
> >> +		int start_min, int length_min, int length_max)
> >>  {
> >>  	if (*length < length_min)
> >>  		*length = length_min;
> > 
> > I still do not believe this function will work equally well with signed 
> > parameters, as it works with unsigned ones.
> 
> I implemented some test cases to find out whether the
> soc_camera_limit_side() works correctly or not. My biggest problem is that I'm
> not sure what is the expected working of the soc_camera_limit_side() function.

Well, the expected behaviour is simple: the function treats all its 
parameters as unsigned, and puts the former two input/output parameters 
within the limits, provided by the latter three parameters. Well, taking 
into account, that when comparing a signed and an unsigned integers, the 
comparison is performed unsigned, I think, it should be ok to do what I 
suggested in the last email: change prototype to

+static inline void soc_camera_limit_side(int *start, int *length,
+		unsigned int start_min, unsigned int length_min, 
+		unsigned int length_max)

Maybe also provide a comment above the function explaining, why the first 
two parameters are signed. And cast explicitly in sh_mobile_ceu_camera.c:

	soc_camera_limit_side(&rect->left, &rect->width,
			      (unsigned int)cap.bounds.left, 2,
			      (unsigned int)cap.bounds.width);
	soc_camera_limit_side(&rect->top, &rect->height,
			      (unsigned int)cap.bounds.top, 4,
			      (unsigned int)cap.bounds.height);

Could you check if this would make both sparse and the compiler happy?

Thanks
Guennadi

> 
> Nevertheless I tried expect some values, you can probably verify whether my
> expectations are correct or not (see the test attached).
> 
> The signed and unsigned version of the function works differently because
> the unsigned version cannot accept negative values. These values will be
> implicitly casted to an unsigned value which means that they will be interpreted
> as a big positive value.
> 
> Here are the test results:
> 
> Test Case 1: PASSED
> Test Case 2: PASSED
> Test Case 3: FAILED: start=50, length=8, start_unsigned=0, length_unsigned=1600
> Test Case 4: PASSED
> Test Case 5: PASSED
> Test Case 6: PASSED
> Test Case 7: PASSED
> Test Case 8: PASSED
> 
> There is a difference in case 3, but which is the correct one?
> 
> Regard,
> 
> 	Márton Németh
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
