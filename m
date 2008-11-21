Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALJ6Gc4001555
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:06:16 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mALJ4vDa011416
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:05:42 -0500
Message-ID: <4927064B.5010900@gmx.net>
Date: Fri, 21 Nov 2008 20:04:43 +0100
From: Roman <muzungu@gmx.net>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <4925D46F.10701@gmx.net>
	<1227234459.4318.14.camel@pc10.localdom.local>
In-Reply-To: <1227234459.4318.14.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Asus PC-39 IR Control: dead keys
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

Hi Hermann

I did not know about those tool written by Gerd.

I think they will do. I downloaded and compiled. The tools are working well.
Until the day X might also accept keycodes above 255 I can now map them 
to some keycode within 0 -255.

Thanks for the hint  and thanks to Gerd for writing them.

Greets

Roman


hermann pitton schrieb:
> Hi Roman,
>
> Am Donnerstag, den 20.11.2008, 22:19 +0100 schrieb Roman:
>   
>> Hi all
>>
>> The keys defined with numbers bigger than 255 in the IR_KEYTAB_TYPE 
>> ir_codes_asus_pc39[IR_KEYTAB_SIZE] do not get recognized by X11 nor the 
>> console.
>>
>> - showkey shows the keycode but no scancode
>> - xev does not react at all on those keys
>> - neither does the console
>> - lineak, as far as I can see, just reacts on keycodes below 256 too, or 
>> in other word on what xev does react.
>>
>> How to solve this? How do I get the keys such as KEY_DVD or KEY_ZOOM 
>> (>255) get to work with an (X) app?
>>
>> The only solution I can see by now, as long as X11 and the kernel 
>> (right?) do not react on key above 255 is
>> - to find me some unused keys below 256,
>> - fill IR_KEYTAB_TYPE ir_codes_asus_pc39[IR_KEYTAB_SIZE] wiht the best 
>> fitting,
>> - and recompile the driver module saa7134 with the new key definitions.
>>
>> This is probably NOT the way to go.
>>
>> Any suggestions?
>>     
>
> Gerd coded the v4l input layer support when 2.6.x was firstly released
> and lirc did not even compile for a long time after that.
>
> You might remember, that on my P7131 Dual replacement card the IR
> receiver is broken and I don't like to molest others with your report,
> until we have something more clear.
>
> First, preload ir-common with debug=1.
> Any unknown keys now? Should not ever happen.
>
> The <= 256 X limitation is known, but input.h should still be valid for
> a multimedia keyboard.
>
> You can try with Gerd's input utils too.
>
> http://dl.bytesex.org/cvs-snapshots
>
> You should be able to dump the keymap of your keyboard and remote > to
> files.
>
> You then can modify the keymap of the remote with valid keys your
> keyboard provides and load it on the fly with something like
> ./ir-kbd -f my-new-keymap-file.
>
> Cheers,
> Hermann
>
>
>
>
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
