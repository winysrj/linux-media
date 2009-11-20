Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:49072 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbZKTUvz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 15:51:55 -0500
Message-ID: <4B070178.6020205@ridgerun.com>
Date: Fri, 20 Nov 2009 14:52:08 -0600
From: Santiago Nunez-Corrales <snunez@ridgerun.com>
Reply-To: santiago.nunez@ridgerun.com
MIME-Version: 1.0
To: Mr Momcilo Medic <medicmomcilo@yahoo.com>
CC: linux-media@vger.kernel.org
References: <84273.93065.qm@web65614.mail.ac4.yahoo.com>
In-Reply-To: <84273.93065.qm@web65614.mail.ac4.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Problem installing driver
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Momcilo,


That error means the code is unable to find the kernel sources 
containing all the definitions from v4l2. Within the driver directory, 
look for a file named Makefile or Rules.make or Makefile.rules. In one 
of those, there should be a variable pointing to the kernel sources in 
your Linux distribution (usually in /usr/src/linux, consult the 
particular documentation in case you need to install the package or 
download from www.kernel.org). Set the variable to your particular 
kernel and recompile.

Regards,

Mr Momcilo Medic wrote:
> Hello,
>
> I am Momcilo Medic from Serbia, and I was advised to write you mail with my problem. I am trying to install simple driver and it returns an error. In attachment is error message as well as driver I am trying to install.
>
> I am pretty much a newbie for Linux, so if I left something out please do tell and I will send as many info as you need.
>
> Thanks in advance,
> Momcilo.
>
>
>       


-- 
Santiago Nunez-Corrales, Eng.
RidgeRun Engineering, LLC

Guayabos, Curridabat
San Jose, Costa Rica
+(506) 2271 1487
+(506) 8313 0536
http://www.ridgerun.com


