Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:2192 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0AEDeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 22:34:18 -0500
Message-ID: <4B42B2C6.8050702@toaster.net>
Date: Mon, 04 Jan 2010 19:32:22 -0800
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
	bugzilla-daemon@bugzilla.kernel.org, linux-media@vger.kernel.org,
	USB list <linux-usb@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bugme-new] [Bug 14564] New: capture-example sleeping function
 called from invalid context at arch/x86/mm/fault.c
References: <Pine.LNX.4.44L0.1001042129530.26506-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001042129530.26506-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> Um, when you say it does the job, what do you mean?
It traps the error and prevents the kernel from crashing.
> The job it was _intended_ to do was to prove that your problems are
> caused by hardware errors rather than software bugs.  If the patch
> causes the problems to stop, without printing any error messages in the
> log, then it does indeed prove this.  After all, the only places the
> patch changes any persistent values are after it prints an error 
> message.
>   
It did print out error messages:
usb 4-2: new full speed USB device using ohci_hcd and address 
2                                   
usb 4-2: New USB device found, idVendor=093a, 
idProduct=2460                                                         
usb 4-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0                                                    
usb 4-2: Product: CIF Single 
Chip                                                                                     

usb 4-2: Manufacturer: Pixart Imaging 
Inc.                                                                            

usb 4-2: configuration #1 chosen from 1 
choice                                                                        

[root@X-Linux]:~ # modprobe 
gspca_pac207                                                                                                 

Linux video capture interface: 
v2.00                                                                                  

gspca: main v2.8.0 
registered                                                                                         

gspca: probing 
093a:2460                                                                                              

pac207: Pixart Sensor ID 0x27 Chips ID 
0x09                                                                           

pac207: Pixart PAC207BCA Image Processor and Control Chip detected 
(vid/pid 0x093A:0x2460)                           
gspca: video0 
created                                                                                                 

usbcore: registered new interface driver 
pac207                                                                       

pac207: 
registered                                                                                                    

[root@X-Linux]:~ # 
capture-example                                                                                    

......................................................................                                                

capture-example used greatest stack depth: 5848 bytes 
left                                                           
[root@X-Linux]:~ # 
capture-example                                                                                    

.ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                 
...ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                               
.ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                 
.ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                 
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                  
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
.ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                 
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                  
....ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                              
ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                  
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
.ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                 
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
.ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                 
.ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                 
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                  
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                  
...ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                               
.ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                 
.ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                 
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                  
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                  
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
.ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                 
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..ohci_hcd 0000:00:0b.0: Circular hash: 32 c669f800 c677b800 
c677b800                                                
ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                  
..ohci_hcd 0000:00:0b.0: Circular hash: 36 c669f900 c677b900 
c677b900                                                
..                                                                                                                    

[root@X-Linux]:~ #
> (Admittedly, I didn't expect the problem to stop; I expected to get a
> bunch of messages from the second ohci_err().  Just out of curiosity, 
> does it make any difference if you remove all those "volatile"s in the 
> declaration line for td1 and td2?)
>   
It doesn't seem to make much difference.
> I noticed that your CPU is a Cyrix.  Perhaps it is the culprit.  Have
> you tried running the program on a different computer?
>   
Yes, on other computers I don't get this error. Same os image. Though I 
haven't found a computer with an ohci controller yet.
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
