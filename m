Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m357budO005617
	for <video4linux-list@redhat.com>; Sat, 5 Apr 2008 03:37:56 -0400
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m357bTKr031553
	for <video4linux-list@redhat.com>; Sat, 5 Apr 2008 03:37:29 -0400
Message-ID: <47F72C14.9080004@hhs.nl>
Date: Sat, 05 Apr 2008 09:36:52 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
References: <47ED68E3.7040400@hhs.nl>	<20080403212728.GE14369@plankton.ifup.org>
	<20080404144935.3b457c69.zaitcev@redhat.com>
In-Reply-To: <20080404144935.3b457c69.zaitcev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: fedora-kernel-list@redhat.com, video4linux-list@redhat.com,
	spca50x-devs@lists.sourceforge.net
Subject: Re: [New Driver]: usbvideo2 webcam core + pac207 driver using it.
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

Pete Zaitcev wrote:
>>> #define CLIP(color) (unsigned char)(((color)>0xFF)?0xff:(((color)<0)?0:(color)))
>> Add a comment about what this is doing?  Could you just do it as a
>> static function instead?
> 
> The macro itself is too trivial to be commented, IMHO, but I have
> to ask just what it is doing there. It is only applied to
> precomputed values from pac207_decompress_table, as far as I see.
> So, they cannot be out of range. Or can they?
> 

Its being applied to the addition of a value read from the sensor and a 
precomputed value from the pac207_decompress_table, and the total of these can 
be out of range.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
