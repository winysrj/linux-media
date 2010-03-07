Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:34352 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab0CGPyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Mar 2010 10:54:36 -0500
Message-ID: <4B93CA68.9060502@crans.ens-cachan.fr>
Date: Sun, 07 Mar 2010 16:46:48 +0100
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: Aslam Mullapilly <aslam@hcscomm.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: Mumudvb Transcoding error
References: <38f022bc1003070017t11140027kfb98f71427f74bfe@mail.gmail.com> <425356A9213FA046A466287AF4E18B19568EB17646@ALH-MAIL.alhgroup.net>
In-Reply-To: <425356A9213FA046A466287AF4E18B19568EB17646@ALH-MAIL.alhgroup.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aslam Mullapilly a écrit :
> Hi,
> 
> I'm trying to run mumudvb with transcoding. Please see my error.
> 
> Input #0, mpegts, from 'stream':
>   Duration: N/A, start: 28021.001044, bitrate: 15128 kb/s
>   Program 2801 Alarabiya
>   Program 2802 MBC1
>   Program 2803 MBC4
>   Program 2804 MBC2
>   Program 2805 MBC3
>   Program 2806 CITRUSS TV
>   Program 2807 HAWAS TV
>   Program 2810 AD Emarat
>   Program 2811 ZEE AFLAM
>   Program 2812 MBC Action
>   Program 2813 Al Eqtisadia TV
>   Program 2814 MBC MAX
> [Transcode] Couldn't find audio encoder.
> [Transcode] Couldn't find video encoder.
> [Transcode] Failed to initialize transcoding.
> 
> 
> Hence, I installed libavcodec-dev libavformat-dev libswscale-dev
> 
> But still I can't find the stream.
> 
> 
> Regards,
> 


Hello

You must give more information, like the configuration file used, and
the output of

ffmpeg -formats

Regards

-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?
