Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KdF0u-0007pS-ED
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 04:01:02 +0200
Received: by yx-out-2324.google.com with SMTP id 8so1284981yxg.41
	for <linux-dvb@linuxtv.org>; Tue, 09 Sep 2008 19:00:56 -0700 (PDT)
Message-ID: <37219a840809091900u344e61dkc1590179ce052c78@mail.gmail.com>
Date: Tue, 9 Sep 2008 22:00:55 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "William Austin" <bsdskin@yahoo.com>
In-Reply-To: <868475.15080.qm@web31102.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <868475.15080.qm@web31102.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1950 with Ubuntu Intrepid
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

William,

On Tue, Sep 9, 2008 at 9:52 PM, William Austin <bsdskin@yahoo.com> wrote:
[snip]
> If I hadn't already checked out the pvrusb2 home page and read the information there, I wouldn't be feeling patronised on a mailing list asking for help.  But then, I understand requests like this can get tedious, so no worries.

Sorry about that... I couldn't know for sure whether you had seen that
website or not.

> I just rebooted with the device unplugged.  Here is the end of my dmesg (the changes after I plugged in the HVR-1950):
> [ 5115.393036] usb 2-2: new high speed USB device using ehci_hcd and address 12
> [ 5115.529015] usb 2-2: configuration #1 chosen from 1 choice
> [ 5115.616658] Linux video capture interface: v2.00
> [ 5115.672945] usbcore: registered new interface driver pvrusb2
> [ 5115.674849] pvrusb2: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner : V4L in-tree version
> [ 5115.674857] pvrusb2: Debug mask is 31 (0x1f)
> [ 5116.673636] firmware: requesting v4l-pvrusb2-73xxx-01.fw
> [ 5116.697396] pvrusb2: Device microcontroller firmware (re)loaded; it should now reset and reconnect.
> [ 5116.861037] usb 2-2: USB disconnect, address 12
> [ 5116.862449] pvrusb2: Device being rendered inoperable
> [ 5118.488036] usb 2-2: new high speed USB device using ehci_hcd and address 13
> [ 5118.625005] usb 2-2: configuration #1 chosen from 1 choice
>
> Now, for the first time (and it'd have to be after I've already written to the list asking about it) it seems to load the firmware correctly; however, I'm still without a device node for it.

Now this is interesting.  Can you show me what lsusb looks like after the above?

Something indeed looks wrong.

Also -- just to confirm -- I am assuming that you are using the stock
intrepid 2.6.27-2 kernel?  Please show me the output from 'uname -r'

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
