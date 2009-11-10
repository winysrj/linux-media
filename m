Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-88-194-224-77.ipcom.comunitel.net ([77.224.194.88]:41415
	"EHLO panicking.kicks-ass.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbZKJKWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 05:22:12 -0500
Received: from [192.168.0.195] (ident=michael)
	by panicking.kicks-ass.org with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <michael@panicking.kicks-ass.org>)
	id 1N7p8N-0007G6-7f
	for linux-media@vger.kernel.org; Tue, 10 Nov 2009 12:43:40 +0100
Message-ID: <4AF93DE5.6060901@panicking.kicks-ass.org>
Date: Tue, 10 Nov 2009 11:18:13 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ov538-ov7690
References: <4AF89498.3000103@panicking.kicks-ass.org>
In-Reply-To: <4AF89498.3000103@panicking.kicks-ass.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Michael Trimarchi wrote:
> Hi all
> 
> I'm working on the ov538 bridge with the ov7690 camera connected. 
> Somentimes I receive
> 
> [ 1268.146705] gspca: ISOC data error: [110] len=1020, status=-71
> [ 1270.946739] gspca: ISOC data error: [114] len=1020, status=-71
> [ 1271.426689] gspca: ISOC data error: [82] len=1020, status=-71
> [ 1273.314640] gspca: ISOC data error: [1] len=1020, status=-71
> [ 1274.114661] gspca: ISOC data error: [17] len=1020, status=-71
> [ 1274.658718] gspca: ISOC data error: [125] len=1020, status=-71
> [ 1274.834666] gspca: ISOC data error: [21] len=1020, status=-71
> [ 1275.666684] gspca: ISOC data error: [94] len=1020, status=-71
> [ 1275.826645] gspca: ISOC data error: [40] len=1020, status=-71
> [ 1276.226721] gspca: ISOC data error: [100] len=1020, status=-71
> 
> This error from the usb, how are they related to the camera?
> 

Ok, this is not a big issue because I can use vlc to test the camera. But anybody
knows why camorama, camstream, cheese crash during test. is it driver depend? or not?

Michael

> Michael
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

