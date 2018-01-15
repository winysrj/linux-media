Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernelconcepts.de ([188.40.83.200]:55673 "EHLO
        mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754755AbeAOKke (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 05:40:34 -0500
Subject: Re: MT9M131 on I.MX6DL CSI color issue
To: Anatolij Gustschin <agust@denx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
 <20180112105840.75260abb@crub> <20180112110606.47499410@crub>
From: Florian Boor <florian.boor@kernelconcepts.de>
Message-ID: <929ef892-467b-dfd1-8ae0-0190263be38a@kernelconcepts.de>
Date: Mon, 15 Jan 2018 11:40:32 +0100
MIME-Version: 1.0
In-Reply-To: <20180112110606.47499410@crub>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Anatolij,

many thanks for explaining. It changed something at least - see below.

On 12.01.2018 11:06, Anatolij Gustschin wrote:
> On Fri, 12 Jan 2018 10:58:40 +0100
> Anatolij Gustschin agust@denx.de wrote:
> ...
> I forgot the videoconvert, sorry. Try
> 
>   gst-launch v4l2src device=/dev/video4 num-buffers=1 ! \
>              filesink location=frame.raw
> 
>   gst-launch filesrc num-buffers=1 Lotion=frame.raw ! \
>              videoparse format=5 width=1280 height=1024 framerate=25/1 ! \
>              videoconvert ! jpegenc ! filesink location=capture1.jpeg

Capturing like this the colors turn a little bit less psychedelic green and
purple. Looks like this:
http://www.kernelconcepts.de/~florian/capture2.jpeg
The dark area is in fact a very bright one. So maybe the format I read from the
sensor is not exactly what it is supposed to be or similar...

Greetings

Florian

-- 
The dream of yesterday                  Florian Boor
is the hope of today                    Tel: +49 271-771091-15
and the reality of tomorrow.		Fax: +49 271-338857-29
[Robert Hutchings Goddard, 1904]        florian.boor@kernelconcepts.de
                                        http://www.kernelconcepts.de/en

kernel concepts GmbH
Hauptstraße 16
D-57074 Siegen
Geschäftsführer: Ole Reinhardt
HR Siegen, HR B 9613
