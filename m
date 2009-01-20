Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0KKpiUa000682
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 15:51:44 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.236])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0KKpRvl031915
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 15:51:27 -0500
Received: by rv-out-0506.google.com with SMTP id f6so3611126rvb.51
	for <video4linux-list@redhat.com>; Tue, 20 Jan 2009 12:51:27 -0800 (PST)
Message-ID: <6dd519ae0901201251wb924d39k468627b7c778e3bf@mail.gmail.com>
Date: Tue, 20 Jan 2009 23:51:27 +0300
From: "Brian Marete" <bgmarete@gmail.com>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <20090119092610.65a2a90a@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6dd519ae0901181629m4a79732ala0daa870cefa74cc@mail.gmail.com>
	<20090119092610.65a2a90a@free.fr>
Cc: Video4linux-list <video4linux-list@redhat.com>
Subject: Re: Problem streaming from gspca_t613 Webcam
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

On Mon, Jan 19, 2009 at 11:26 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Mon, 19 Jan 2009 03:29:29 +0300
> "Brian Marete" <bgmarete@gmail.com> wrote:
>
>> Hello,
>>
>> I have a USB camera using the gspca_t613 driver. Its vendor/model ID
>> is 17a1:0128.
>>
>> I am using kernel 2.6.28.1
>>
>> I get a blank screen when I try to access it from skype or aMSN, and
>> the following MPlayer commands gives a constant stream of "select
>> timeout" error messages:
>> mplayer tv:// -tv
>> device=/dev/video0:driver=v4l2:outfmt=mjpeg:fps=7:width=640:height=480
>>
>> Loading the gspca module with the option debug=511 gives the following
>> output in the kernel log from module load to a couple of minutes of
>> the above MPlayer command:
>>
>> Jan 19 01:55:28 oqb kernel: [   93.376076] usb 3-2: new full speed USB
>> device using uhci_hcd and address 3
>> Jan 19 01:55:28 oqb kernel: [   93.533862] usb 3-2: configuration #1
>> chosen from 1 choice
>> Jan 19 01:55:28 oqb kernel: [   93.718772] Linux video capture
>> interface: v2.00 Jan 19 01:55:28 oqb kernel: [   93.749063] gspca:
>> main v2.3.0 registered
>        [snip]
>
> Hello Brian,
>
> You should get a newer version of gspca. Look at the gspca_README.txt
> in my page (see below).
>
> Regards.

Hello Jean-Francois,

No luck with tar ball from http://linuxtv.org/hg/~jfrancois/gspca/
downloaded yesterday. Following is output of dmesg after turning on
debug as instructed in the README on your site. It represents several
attempts to stream from the camera, using svv and MPlayer. With
MPlayer, I even tried to stream 160x120 size frames. MPlayer still
gives a constant stream of "select timeout" messages. svv just gives a
blank screen. But using `svv -g' also gives a select timeout message.

Please tell me if I should provide more information. If there is some
structure or data in the source files I should play with in trying to
get it to work, I am happy to do so. Also, I can capture USB traffic
on Windows.

Thanks.

--------

[ 5931.541087] usb 3-2: new full speed USB device using uhci_hcd and address 5
[ 5931.706343] usb 3-2: configuration #1 chosen from 1 choice
[ 5931.708240] gspca: probing 17a1:0128
[ 5932.232060] t613: Bad sensor reset 01
[ 5932.276423] gspca: probe ok
[ 6070.539796] gspca: svv open
[ 6070.539803] gspca: open done
[ 6070.540288] gspca: try fmt cap JPEG 640x480
[ 6070.540296] gspca: try fmt cap JPEG 640x480
[ 6070.540361] gspca: frame alloc frsz: 115790
[ 6070.540450] gspca: reqbufs st:0 c:4
[ 6070.540476] gspca: mmap start:b7347000 size:118784
[ 6070.540509] gspca: mmap start:b732a000 size:118784
[ 6070.540539] gspca: mmap start:b730d000 size:118784
[ 6070.540567] gspca: mmap start:b72f0000 size:118784
[ 6070.540617] gspca: init transfer alt 3
[ 6070.540621] gspca: use alt 2 ep 0x81
[ 6070.550774] gspca: isoc 32 pkts size 1023 = bsize:32736
[ 6070.589724] gspca: stream on OK JPEG 640x480
[ 6072.129755] gspca: kill transfer
[ 6072.133019] gspca: stream off OK
[ 6072.133120] gspca: svv close
[ 6072.133123] gspca: frame free
[ 6072.133202] gspca: close done
[ 6078.061764] gspca: svv open
[ 6078.061770] gspca: open done
[ 6078.062207] gspca: try fmt cap JPEG 640x480
[ 6078.062215] gspca: try fmt cap JPEG 640x480
[ 6078.062272] gspca: frame alloc frsz: 115790
[ 6078.062361] gspca: reqbufs st:0 c:4
[ 6078.062382] gspca: mmap start:b72f4000 size:118784
[ 6078.062418] gspca: mmap start:b72d7000 size:118784
[ 6078.062447] gspca: mmap start:b72ba000 size:118784
[ 6078.062476] gspca: mmap start:b729d000 size:118784
[ 6078.062524] gspca: init transfer alt 3
[ 6078.062529] gspca: use alt 2 ep 0x81
[ 6078.073107] gspca: isoc 32 pkts size 1023 = bsize:32736
[ 6078.108884] gspca: stream on OK JPEG 640x480
[ 6184.706818] gspca: kill transfer
[ 6184.714463] gspca: stream off OK
[ 6184.714570] gspca: svv close
[ 6184.714574] gspca: frame free
[ 6184.714659] gspca: close done
[ 6195.739355] gspca: mplayer open
[ 6195.739362] gspca: open done
[ 6195.755168] gspca: try fmt cap JPEG 640x480
[ 6195.755335] gspca: try fmt cap MJPG 640x480
[ 6195.755597] gspca: try fmt cap JPEG 640x480
[ 6195.755603] gspca: try fmt cap JPEG 640x480
[ 6195.755721] gspca: frame alloc frsz: 115790
[ 6195.755793] gspca: reqbufs st:0 c:2
[ 6195.755805] gspca: mmap start:b68dc000 size:118784
[ 6195.755831] gspca: mmap start:b68bf000 size:118784
[ 6195.755951] gspca: set ctrl [00980900] = 8
[ 6195.756046] gspca: set ctrl [00980902] = 5
[ 6195.756052] gspca: set ctrl [00980901] = 7
[ 6195.851854] gspca: init transfer alt 3
[ 6195.851859] gspca: use alt 2 ep 0x81
[ 6195.856873] gspca: isoc 32 pkts size 1023 = bsize:32736
[ 6195.896038] gspca: stream on OK JPEG 640x480
[ 6216.966409] gspca: kill transfer
[ 6216.968584] gspca: stream off OK
[ 6216.970346] gspca: mplayer close
[ 6216.970350] gspca: frame free
[ 6216.970398] gspca: close done
[ 6317.173376] gspca: mplayer open
[ 6317.173384] gspca: open done
[ 6317.174381] gspca: try fmt cap JPEG 640x480
[ 6317.174525] gspca: try fmt cap MJPG 640x480
[ 6317.174687] gspca: try fmt cap JPEG 160x480
[ 6317.174691] gspca: try fmt cap JPEG 160x120
[ 6317.174793] gspca: frame alloc frsz: 10190
[ 6317.174834] gspca: reqbufs st:0 c:2
[ 6317.174846] gspca: mmap start:b687e000 size:12288
[ 6317.174857] gspca: mmap start:b687b000 size:12288
[ 6317.174941] gspca: set ctrl [00980900] = 8
[ 6317.174995] gspca: set ctrl [00980902] = 5
[ 6317.174998] gspca: set ctrl [00980901] = 7
[ 6317.200939] gspca: init transfer alt 3
[ 6317.200943] gspca: use alt 2 ep 0x81
[ 6317.209276] gspca: isoc 32 pkts size 1023 = bsize:32736
[ 6317.250267] gspca: stream on OK JPEG 160x120
[ 6332.313577] gspca: kill transfer
[ 6332.319952] gspca: stream off OK
[ 6332.323064] gspca: mplayer close
[ 6332.323068] gspca: frame free
[ 6332.323084] gspca: close done
[ 6372.118075] gspca: svv open
[ 6372.118081] gspca: open done
[ 6372.118546] gspca: try fmt cap JPEG 640x480
[ 6372.118554] gspca: try fmt cap JPEG 640x480
[ 6372.118614] gspca: frame alloc frsz: 115790
[ 6372.118734] gspca: reqbufs st:0 c:4
[ 6372.118758] gspca: mmap start:b7268000 size:118784
[ 6372.118792] gspca: mmap start:b724b000 size:118784
[ 6372.118821] gspca: mmap start:b722e000 size:118784
[ 6372.118848] gspca: mmap start:b7211000 size:118784
[ 6372.118899] gspca: init transfer alt 3
[ 6372.118903] gspca: use alt 2 ep 0x81
[ 6372.129809] gspca: isoc 32 pkts size 1023 = bsize:32736
[ 6372.168296] gspca: stream on OK JPEG 640x480
[ 6391.369648] gspca: kill transfer
[ 6391.377714] gspca: stream off OK
[ 6391.377826] gspca: svv close
[ 6391.377830] gspca: frame free
[ 6391.377921] gspca: close done

-- 
B. Gitonga Marete
Tel: +254-722-151-590

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
