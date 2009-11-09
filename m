Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-88-194-224-77.ipcom.comunitel.net ([77.224.194.88]:58987
	"EHLO panicking.kicks-ass.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755201AbZKIW77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2009 17:59:59 -0500
Received: from michael.panicking ([192.168.0.192] ident=michael)
	by panicking.kicks-ass.org with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <michael@panicking.kicks-ass.org>)
	id 1N7drI-0006g2-VH
	for linux-media@vger.kernel.org; Tue, 10 Nov 2009 00:41:17 +0100
Message-ID: <4AF89498.3000103@panicking.kicks-ass.org>
Date: Mon, 09 Nov 2009 23:15:52 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: ov538-ov7690
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

I'm working on the ov538 bridge with the ov7690 camera connected. Somentimes I receive

[ 1268.146705] gspca: ISOC data error: [110] len=1020, status=-71
[ 1270.946739] gspca: ISOC data error: [114] len=1020, status=-71
[ 1271.426689] gspca: ISOC data error: [82] len=1020, status=-71
[ 1273.314640] gspca: ISOC data error: [1] len=1020, status=-71
[ 1274.114661] gspca: ISOC data error: [17] len=1020, status=-71
[ 1274.658718] gspca: ISOC data error: [125] len=1020, status=-71
[ 1274.834666] gspca: ISOC data error: [21] len=1020, status=-71
[ 1275.666684] gspca: ISOC data error: [94] len=1020, status=-71
[ 1275.826645] gspca: ISOC data error: [40] len=1020, status=-71
[ 1276.226721] gspca: ISOC data error: [100] len=1020, status=-71

This error from the usb, how are they related to the camera?

Michael
