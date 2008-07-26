Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6Q0Gf6n021455
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 20:16:41 -0400
Received: from akbkhome.com (246-113.netfront.net [202.81.246.113])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6Q0GU1H011068
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 20:16:31 -0400
Message-ID: <488A6CD9.6060107@akbkhome.com>
Date: Sat, 26 Jul 2008 08:16:25 +0800
From: Alan Knowles <alan@akbkhome.com>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <48898289.2070305@akbkhome.com>
	<d9def9db0807250906q4918121awceb6e0f938088e6d@mail.gmail.com>
In-Reply-To: <d9def9db0807250906q4918121awceb6e0f938088e6d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: ASUS My Cinema-U3100Mini/DMB-TH (Legend Slilicon 8934)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


snip .....
>> [353408.680977] DVB: registering new adapter (ASUSTeK DMB-TH)
>> [302530.670387]  Cannot find LGS8934
>>     
>
> this is basically the problem here.
>
>   
Which along with:

= the binary modules released by asus for the eeepc for this device 
(which I've heard works)

dib3000mc.ko       dvb-core.ko               dvb-usb-dibusb-mc.ko
dibx000_common.ko  dvb-usb-dibusb-common.ko  dvb-usb.ko

* note - no adimtv module...? - I'm guessing it uses one of the existing 
tuners..

doing a strings on dib3000mc.ko finds a few interesting items:

# strings dib3000mc.ko  | grep -i dmbth

u3100DMBTH set freq=%d
u3100dmbth init
u3100dmbth 8GL5 init <-- a known ledgend chip for DMB-TH (and the code 
is not in the tarball)
u3100dmbth 8934 init
U3100-DMBTH Device ID: %d
 
So since those strings are missing from the source file, I'm pretty 
convinced they released the wrong code..

Regards
Alan


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
