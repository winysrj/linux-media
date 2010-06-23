Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.telson.es ([212.163.44.111]:12514 "EHLO smtp.telson.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab0FWQ2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jun 2010 12:28:23 -0400
From: Gmail <tassbur@gmail.com>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Record from DVB tuner
Date: Wed, 23 Jun 2010 18:18:09 +0200
References: <AANLkTinks_MHz5R7DzcR712IuZlLe54NXbvlvIfk2DJI@mail.gmail.com>
In-Reply-To: <AANLkTinks_MHz5R7DzcR712IuZlLe54NXbvlvIfk2DJI@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006231818.11191.tassbur@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I think the best it's using dvbstream with -o parameter with pipes, tee and ts_filter
For example:

dvbstream ........ -o 8192 | tee pids > file | tee 
		>(ts_filter pids > file) \ 
		> (ts_filter another_pids > file)

I hope this can help you.

On Miércoles, 23 de Junio de 2010 18:02:36 shacky escribió:
> Hi.
> 
> I need to record some DVB channels from the command line using a
> supported DVB tuner PCI card on Linux Debian.
> I know I can tune the DVB adapter using dvbtools and record the raw
> input using cat from /dev/dvb/adapter0, but what about recording two
> or more different channels from the same multiplex?
> How I can do this from the command line?
> Could you help me please?
> 
> Thank you very much!
> Bye.
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
