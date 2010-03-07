Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.hejailan.com ([82.205.218.163]:1758 "EHLO
	alhimss.alhgroup.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751889Ab0CGP10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 10:27:26 -0500
From: Aslam Mullapilly <aslam@hcscomm.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Sun, 7 Mar 2010 18:27:05 +0300
Subject: Mumudvb Transcoding error
Message-ID: <425356A9213FA046A466287AF4E18B19568EB17646@ALH-MAIL.alhgroup.net>
References: <38f022bc1003070017t11140027kfb98f71427f74bfe@mail.gmail.com>
In-Reply-To: <38f022bc1003070017t11140027kfb98f71427f74bfe@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to run mumudvb with transcoding. Please see my error.

Input #0, mpegts, from 'stream':
  Duration: N/A, start: 28021.001044, bitrate: 15128 kb/s
  Program 2801 Alarabiya
  Program 2802 MBC1
  Program 2803 MBC4
  Program 2804 MBC2
  Program 2805 MBC3
  Program 2806 CITRUSS TV
  Program 2807 HAWAS TV
  Program 2810 AD Emarat
  Program 2811 ZEE AFLAM
  Program 2812 MBC Action
  Program 2813 Al Eqtisadia TV
  Program 2814 MBC MAX
[Transcode] Couldn't find audio encoder.
[Transcode] Couldn't find video encoder.
[Transcode] Failed to initialize transcoding.


Hence, I installed libavcodec-dev libavformat-dev libswscale-dev

But still I can't find the stream.


Regards,

Aslam
