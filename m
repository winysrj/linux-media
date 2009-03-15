Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60461 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753027AbZCONUN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 09:20:13 -0400
Message-ID: <49BD0088.6050203@gmx.de>
Date: Sun, 15 Mar 2009 14:20:08 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
References: <49B9BC93.8060906@nav6.org>	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>	 <49B9DECC.5090102@nav6.org>	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>	 <37219a840903131452mf8b7969h881a24fc2dd031e8@mail.gmail.com>	 <a3ef07920903131527x2762f6e6y18f3a0b825ff2a49@mail.gmail.com> <412bdbff0903131531y3dcb5382red13ac1e4d43feaf@mail.gmail.com>
In-Reply-To: <412bdbff0903131531y3dcb5382red13ac1e4d43feaf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller schrieb:
> On Fri, Mar 13, 2009 at 6:27 PM, VDR User <user.vdr@gmail.com> wrote:
>   
>> Just wanted to comment that I'm glad there is a lot of interest in
>> this.  I've heard endless talk & confusion on the user end over the
>> years as to the accuracy of the values, or in some cases (as with
>> Genpix adapters for example) where you don't seem to get any useful
>> information.  Of course making it really hard for people who are
>> trying to aim dishes and the like in the case of dvb-s*.
>>
>> A quick question about implimenting this though..  What's the most
>> difficult component?
>>     
>
> Hello,
>
> There are basically two "difficult components"
>
> 1.  Getting everyone to agree on a standard representation for the
> field, and how to represent certain error conditions (such as when a
> demod doesn't support SNR, or when it cannot return a valid value at a
> given time).
>
>   
Its just straightforward as described in DVB API, chapters
2.2.3 FE READ STATUS
2.2.4 FE READ BER
2.2.5 FE READ SNR
2.2.6 FE READ SIGNAL STRENGTH
2.2.7 FE READ UNCORRECTED BLOCKS

if ioctl suceeds with valid data: 0, if not one of
EBADF            no valid file descriptor.
EFAULT          error condition
ENOSIGNAL  not yet, i have no signal..
ENOSYS         not supported by device.

> 2.  Converting all the drivers to the agreed-upon format.  For some
> drivers this is relatively easy as we have specs available for how the
> SNR is represented.  For others, the value displayed is entirely
> reverse engineered so the current representations are completely
> arbitrary.
>
> Devin
>
>   
Since a lot of frontends have no proper docs, probably providing the 
signal strength unit with a second ioctl could make sense here.

a.u.          arbitrary units, not exactly known or not perfectly working
dBµV       comparable trough all devices, but probably not possible for all
percent     technical not understandable, percent relative to what? 
Assumes that there is a optimum/hard limit of 100% which is not the case.

Showing values as human readings is on the app side, so hex output in 
raw numbers are just fine here. No change needed.

-- Winfried
