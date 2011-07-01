Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab1GAOcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 10:32:21 -0400
Message-ID: <4E0DDA71.6080104@redhat.com>
Date: Fri, 01 Jul 2011 11:32:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Charan Prakash <charandp66@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Uinstalling V4L/DVB drivers
References: <BANLkTikS1QA1B-_bvr2TKT7xq1PpAJof4w@mail.gmail.com>
In-Reply-To: <BANLkTikS1QA1B-_bvr2TKT7xq1PpAJof4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-07-2011 11:01, Charan Prakash escreveu:
> Hi,
>  Im try to develop code for Kinect camera of XBOX. The USB interface was
> working fine until I tried installing your drivers as given in this page:
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
> I followed all instructions in that page till 'make install' in "Installing
> the compiled Driver Modules".
> 
> Then when I restarted i get a message  (It stays for s very short interval
> for me to read) before boot up and since then whenever i try to run an
> Kinect code i get an error message "Failed to set USB interface!"

Well, there's now a kernel driver for Kinect.

> Is there any way where I can unistall your drivers. 

"make rminstall" target at the media-build will remove all media drivers from
your tree, but why don't you simply use the existing driver or improve it?

Please help me since I
> am new to Linux and I have to develop this code  within a very short time.
> 
> Thank you,
> Charan Prakash
> Graduate Student
> Department of Electrical Engineering
> Arizona State University
> 

