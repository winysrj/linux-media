Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB2M0SNk002977
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 17:00:28 -0500
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB2M0BiB031988
	for <video4linux-list@redhat.com>; Tue, 2 Dec 2008 17:00:11 -0500
Message-ID: <4935AFF4.2040406@free.fr>
Date: Tue, 02 Dec 2008 23:00:20 +0100
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Chris Grove <dj_gerbil@tiscali.co.uk>
References: <002901c95150$44c16b90$ce4442b0$@co.uk>
	<4931ADCD.2000407@free.fr>	<011901c952f4$a02d9710$e088c530$@co.uk>
	<4932ACE9.7030309@free.fr> <012301c95302$6eed5f60$4cc81e20$@co.uk>
	<013f01c9532a$8dcbdf10$a9639d30$@co.uk> <493301D5.5050001@free.fr>
	<000301c95341$504c5810$f0e50830$@co.uk> <493451C5.9010406@free.fr>
	<00bf01c95402$ae3c6070$0ab52150$@co.uk>
In-Reply-To: <00bf01c95402$ae3c6070$0ab52150$@co.uk>
Content-Type: multipart/mixed; boundary="------------050307090401030305030804"
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge WinTV USB Model 566 PAL-I
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

This is a multi-part message in MIME format.
--------------050307090401030305030804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Chris Grove a écrit :
> -----Original Message-----
> From: Thierry Merle [mailto:thierry.merle@free.fr] 
> Sent: 01 December 2008 21:06
> To: Chris Grove
> Subject: Re: Hauppauge WinTV USB Model 566 PAL-I
> 
> Chris Grove wrote:
>> -----Original Message-----
>> From: Thierry Merle [mailto:thierry.merle@free.fr]
>> Sent: 30 November 2008 21:13
>> To: Chris Grove
>> Cc: video4linux-list@redhat.com
>> Subject: Re: Hauppauge WinTV USB Model 566 PAL-I
>>
>> Chris Grove wrote:
>>> A further, slightly interesting development is that the s-video input 
>>> works fine with no interference at all, also the TV picture in fine 
>>> in
>> windows.
>>> Just thought that might help with a solution.
>>>
>> Right, this helps. We can deduce this does not come from the 
>> decompression algorithm since it is the same whether the TV input or 
>> the s-video input is selected.
>> I suspect a tda9887/saa7113 interface problem but just my intuition.
>> As it works under windows, can you do an usbsnoop
>> (http://www.linuxtv.org/v4lwiki/index.php/Usbsnoop)
>> Just open the TV application, let it tune the channel and stop the 
>> application immediately in order to have a minimal capture file.
>>
>> For the audio over USB, in the ancient times I developed a audio 
>> extension for usbvision. I don't even know what I did from it. I can 
>> look for it if you want. I will need to sweep the dust (compilation 
>> errors and so on) but should work.
>>
>> P.S.: this thread is really hard to follow now... please reply under 
>> my answer so that we will be able to read that again :)
>>
>> Hi, yea sorry about that, Outlook always starts at the top of the message.
>> Anyway, I've used USB Snoop and ended up with a 45Mb file. Now I'm 
>> guessing you don't need all of it so there is a portion of it below my 
>> answer. As for the audio-over-usb, yes please, I wouldn't mind a look 
>> at the code if you can find it. Anyway here's that sample, Thanks for the
> help.
> I found the audio-over-usb code (see attached). The code may need some
> cleanups and can cause kernel oops.
> The USB snoops need to be analyzed. Can you put it on a site so that I can
> download it?
> Nevertheless you can read what I wrote when I was programming the
> audio-over-usb driver here:
> http://thierry.merle.free.fr/articles.php?lng=en&pg=82
> The page was translated to English using google translate so there may be
> some problems of understanding :) For some more information about the
> usbvision chip, I wrote a page here:
> http://thierry.merle.free.fr/articles.php?lng=en&pg=68
> 
> As a first step, I will look at the register accesses. They begin with a
> line like this:
> 00000000: 00000000: 42 33 00 00
> With the datasheet I can understand what the windows driver is setting.
> 
> [SNIP]
> 
>> -- URB_FUNCTION_CONTROL_TRANSFER:
>>   PipeHandle           = 8ac23cfc [endpoint 0x00000001]
>>   TransferFlags        = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
>> ~USBD_SHORT_TRANSFER_OK)
>>   TransferBufferLength = 00000001
>>   TransferBuffer       = a1745938
>>   TransferBufferMDL    = 00000000
>>     00000000: 30
>>   UrbLink              = 00000000
>>   SetupPacket          =
>>     00000000: 42 33 00 00 07 00 01 00
> For example here you have a register programming #07 (SER_MODE from the
> NT1004 datasheet).
> Value is 0x30 (TransferBufferMDL line). Means MODE=3.
> This is just for the example, this one is not interesting.
> There are other registers more interesting but I should have the complete
> log to find out.
> 
> You may have sent me the sufficient data to investigate but in doubt give me
> the complete logs.
> Of course you can look at the problem if you are interested.
> 
> Thanks
> Thierry
> 
> Hi Thierry, Thanks for the links to you code, I'll download it and have a
> look. Here's hoping I can work out what's going on in it. I've uploaded the
> whole of the log to my skydrive, the link is below. 
> http://cid-19380f9184511dde.skydrive.live.com/browse.aspx/Public
> To be honest I'm only a learner when it comes to linux and c++ programming,
> I'm more of a basic programmer so I need all the help I can get my hands on.
> Thanks in advance for all your help. Chris. 
> 
> 
OK I have made a quick and dirty perl script that parses the usb snoop file and outputs register programming values.
Usage: usbvision_snoop_extract.pl <UsbSnoop.log

A line is interesting:
Command=USBVISION_LXSIZE_I[00 08 00] value=c0 02 20 01 06 00 01 00
Tells that you must set the X offset to 0x0006 and Y offset 0x0001 (data are swapped).
Please try modprobe usbvision adjust_X_Offset=6 adjust_Y_Offset=1
Thierry

--------------050307090401030305030804
Content-Type: text/plain;
 name="usbvision_snoop_extract.pl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usbvision_snoop_extract.pl"

#!/usr/bin/perl -w
#

$register[0]= "USBVISION_PWR_REG";
$register[0x01]= "USBVISION_CONFIG_REG";
$register[0x02] = "USBVISION_ADRS_REG";
$register[0x03] = "USBVISION_ALTER_REG";
$register[0x04] = "USBVISION_FORCE_ALTER_REG";
$register[0x05] = "USBVISION_STATUS_REG";
$register[0x06] = "USBVISION_IOPIN_REG";
$register[0x07] = "USBVISION_SER_MODE";
$register[0x08] = "USBVISION_SER_ADRS";
$register[0x09] = "USBVISION_SER_CONT";
$register[0x0A] = "USBVISION_SER_DAT1";
$register[0x0B] = "USBVISION_SER_DAT2";
$register[0x0C] = "USBVISION_SER_DAT3";
$register[0x0D] = "USBVISION_SER_DAT4";
$register[0x0E] = "USBVISION_EE_DATA";
$register[0x0F] = "USBVISION_EE_LSBAD";
$register[0x10] = "USBVISION_EE_CONT";
$register[0x12] = "USBVISION_DRM_CONT";
$register[0x13] = "USBVISION_DRM_PRM1";
$register[0x14] = "USBVISION_DRM_PRM2";
$register[0x15] = "USBVISION_DRM_PRM3";
$register[0x16] = "USBVISION_DRM_PRM4";
$register[0x17] = "USBVISION_DRM_PRM5";
$register[0x18] = "USBVISION_DRM_PRM6";
$register[0x19] = "USBVISION_DRM_PRM7";
$register[0x1A] = "USBVISION_DRM_PRM8";
$register[0x1B] = "USBVISION_VIN_REG1";
$register[0x1C] = "USBVISION_VIN_REG2";
$register[0x1D] = "USBVISION_LXSIZE_I";
$register[0x1E] = "USBVISION_MXSIZE_I";
$register[0x1F] = "USBVISION_LYSIZE_I";
$register[0x20] = "USBVISION_MYSIZE_I";
$register[0x21] = "USBVISION_LX_OFFST";
$register[0x22] = "USBVISION_MX_OFFST";
$register[0x23] = "USBVISION_LY_OFFST";
$register[0x24] = "USBVISION_MY_OFFST";
$register[0x25] = "USBVISION_FRM_RATE";
$register[0x26] = "USBVISION_LXSIZE_O";
$register[0x27] = "USBVISION_MXSIZE_O";
$register[0x28] = "USBVISION_LYSIZE_O";
$register[0x29] = "USBVISION_MYSIZE_O";
$register[0x2A] = "USBVISION_FILT_CONT";
$register[0x2B] = "USBVISION_VO_MODE";
$register[0x2C] = "USBVISION_INTRA_CYC";
$register[0x2D] = "USBVISION_STRIP_SZ";
$register[0x2E] = "USBVISION_FORCE_INTRA";
$register[0x2F] = "USBVISION_FORCE_UP";
$register[0x30] = "USBVISION_BUF_THR";
$register[0x31] = "USBVISION_DVI_YUV";
$register[0x32] = "USBVISION_AUDIO_CONT";
$register[0x33] = "USBVISION_AUD_PK_LEN";
$register[0x34] = "USBVISION_BLK_PK_LEN";
$register[0x38] = "USBVISION_PCM_THR1";
$register[0x39] = "USBVISION_PCM_THR2";
$register[0x3A] = "USBVISION_DIST_THR_L";
$register[0x3B] = "USBVISION_DIST_THR_H";
$register[0x3C] = "USBVISION_MAX_DIST_L";
$register[0x3D] = "USBVISION_MAX_DIST_H";

while (<STDIN>) {
    if(/\s+TransferBufferMDL.*$/)
    {
	    $newTag=1;
    }
    if(/\s*00000000: 42 33 00 00\s+(\w+)\s+(.+)$/)
    {
	    printf("Command=%s[%s] value=%s\n",$register[hex($1)],$2,$value); $newTag=0;
    }
    else {
	if(/\s*00000000:\s*(.+)$/)
	{
	    $value=$1;
	}
    }
}


--------------050307090401030305030804
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050307090401030305030804--
