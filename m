Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f216.google.com ([209.85.220.216]:41339 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZISO4e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 10:56:34 -0400
Received: by fxm12 with SMTP id 12so1342191fxm.18
        for <linux-media@vger.kernel.org>; Sat, 19 Sep 2009 07:56:36 -0700 (PDT)
Message-ID: <4AB4EFFD.806@gmail.com>
Date: Sat, 19 Sep 2009 16:51:41 +0200
From: fogna <fogna80@gmail.com>
MIME-Version: 1.0
To: Adriano Gigante <adrigiga@yahoo.it>
CC: linux-media@vger.kernel.org
Subject: Re: driver for Cinergy Hybrid T USB XS FM
References: <4AB4E526.2080109@yahoo.it>
In-Reply-To: <4AB4E526.2080109@yahoo.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adriano Gigante wrote:
> Hy all,
>
> after Markus Rechberger has discontinued the development of em28xx-new 
> kernel driver, device "Terratec Cinergy Hybrid T USB XS FM" is no more 
> supported under linux.
> I also built and installed from http://linuxtv.org/hg/v4l-dvb sources 
> with no success (it creates /dev/video0 /dev/radio0 /dev/radio1 -no 
> dvb - and nothing works).
>
> The device id is 0ccd:0072, and from Terratec site I saw it's based on 
> Empia em2882 and Xceive 5000 chips.
>
> Someone could help with infos about this stick
>
> Thanks all people.
>
> Adri
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
i have exactly the same problem, the current drivers can't detect the 
stick, here is the lsusb output, thanks in advance

Bus 001 Device 005: ID 0ccd:0072 TerraTec Electronic GmbH
Device Descriptor:                                       
  bLength                18                              
  bDescriptorType         1                              
  bcdUSB               2.00                              
  bDeviceClass            0 (Defined at Interface level) 
  bDeviceSubClass         0                              
  bDeviceProtocol         0                              
  bMaxPacketSize0        64                              
  idVendor           0x0ccd TerraTec Electronic GmbH     
  idProduct          0x0072                              
  bcdDevice            1.10                              
  iManufacturer           0                              
  iProduct                1 Cinergy Hybrid T USB XS FM   
  iSerial                 2 080202004266                 
  bNumConfigurations      1                              
  Configuration Descriptor:                              
    bLength                 9                            
    bDescriptorType         2                            
    wTotalLength          305                            
    bNumInterfaces          1                            
    bConfigurationValue     1                            
    iConfiguration          0                            
    bmAttributes         0x80                            
      (Bus Powered)                                      
    MaxPower              500mA                          
    Interface Descriptor:                                
      bLength                 9                          
      bDescriptorType         4                          
      bInterfaceNumber        0                          
      bAlternateSetting       0                          
      bNumEndpoints           4                          
      bInterfaceClass       255 Vendor Specific Class    
      bInterfaceSubClass      0                          
      bInterfaceProtocol    255                          
      iInterface              0                          
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x81  EP 1 IN               
        bmAttributes            3                        
          Transfer Type            Interrupt             
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0001  1x 1 bytes            
        bInterval              11                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x82  EP 2 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0000  1x 0 bytes            
        bInterval               1                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x83  EP 3 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0000  1x 0 bytes            
        bInterval               4                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x84  EP 4 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0000  1x 0 bytes            
        bInterval               1                        
    Interface Descriptor:                                
      bLength                 9                          
      bDescriptorType         4                          
      bInterfaceNumber        0                          
      bAlternateSetting       1                          
      bNumEndpoints           4                          
      bInterfaceClass       255 Vendor Specific Class    
      bInterfaceSubClass      0                          
      bInterfaceProtocol    255                          
      iInterface              0                          
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x81  EP 1 IN               
        bmAttributes            3                        
          Transfer Type            Interrupt             
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0001  1x 1 bytes            
        bInterval              11                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x82  EP 2 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0000  1x 0 bytes            
        bInterval               1                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x83  EP 3 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x00c4  1x 196 bytes          
        bInterval               4                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x84  EP 4 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0234  1x 564 bytes          
        bInterval               1                        
    Interface Descriptor:                                
      bLength                 9                          
      bDescriptorType         4                          
      bInterfaceNumber        0                          
      bAlternateSetting       2                          
      bNumEndpoints           4                          
      bInterfaceClass       255 Vendor Specific Class    
      bInterfaceSubClass      0                          
      bInterfaceProtocol    255                          
      iInterface              0                          
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x81  EP 1 IN               
        bmAttributes            3                        
          Transfer Type            Interrupt             
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0001  1x 1 bytes            
        bInterval              11                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x82  EP 2 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0ad4  2x 724 bytes          
        bInterval               1                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x83  EP 3 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x00c4  1x 196 bytes          
        bInterval               4                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x84  EP 4 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0234  1x 564 bytes          
        bInterval               1                        
    Interface Descriptor:                                
      bLength                 9                          
      bDescriptorType         4                          
      bInterfaceNumber        0                          
      bAlternateSetting       3                          
      bNumEndpoints           4                          
      bInterfaceClass       255 Vendor Specific Class    
      bInterfaceSubClass      0                          
      bInterfaceProtocol    255                          
      iInterface              0                          
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x81  EP 1 IN               
        bmAttributes            3                        
          Transfer Type            Interrupt             
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0001  1x 1 bytes            
        bInterval              11                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x82  EP 2 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0c00  2x 1024 bytes         
        bInterval               1                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x83  EP 3 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x00c4  1x 196 bytes          
        bInterval               4                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x84  EP 4 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0234  1x 564 bytes          
        bInterval               1                        
    Interface Descriptor:                                
      bLength                 9                          
      bDescriptorType         4                          
      bInterfaceNumber        0                          
      bAlternateSetting       4                          
      bNumEndpoints           4                          
      bInterfaceClass       255 Vendor Specific Class    
      bInterfaceSubClass      0                          
      bInterfaceProtocol    255                          
      iInterface              0                          
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x81  EP 1 IN               
        bmAttributes            3                        
          Transfer Type            Interrupt             
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0001  1x 1 bytes            
        bInterval              11                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x82  EP 2 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x1300  3x 768 bytes          
        bInterval               1                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x83  EP 3 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x00c4  1x 196 bytes          
        bInterval               4                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x84  EP 4 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0234  1x 564 bytes          
        bInterval               1                        
    Interface Descriptor:                                
      bLength                 9                          
      bDescriptorType         4                          
      bInterfaceNumber        0                          
      bAlternateSetting       5                          
      bNumEndpoints           4                          
      bInterfaceClass       255 Vendor Specific Class    
      bInterfaceSubClass      0                          
      bInterfaceProtocol    255                          
      iInterface              0                          
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x81  EP 1 IN               
        bmAttributes            3                        
          Transfer Type            Interrupt             
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0001  1x 1 bytes            
        bInterval              11                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x82  EP 2 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x135c  3x 860 bytes          
        bInterval               1                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x83  EP 3 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x00c4  1x 196 bytes          
        bInterval               4                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x84  EP 4 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0234  1x 564 bytes          
        bInterval               1                        
    Interface Descriptor:                                
      bLength                 9                          
      bDescriptorType         4                          
      bInterfaceNumber        0                          
      bAlternateSetting       6                          
      bNumEndpoints           4                          
      bInterfaceClass       255 Vendor Specific Class    
      bInterfaceSubClass      0                          
      bInterfaceProtocol    255                          
      iInterface              0                          
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x81  EP 1 IN               
        bmAttributes            3                        
          Transfer Type            Interrupt             
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0001  1x 1 bytes            
        bInterval              11                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x82  EP 2 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x13c4  3x 964 bytes          
        bInterval               1                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x83  EP 3 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x00c4  1x 196 bytes          
        bInterval               4                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x84  EP 4 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0234  1x 564 bytes          
        bInterval               1                        
    Interface Descriptor:                                
      bLength                 9                          
      bDescriptorType         4                          
      bInterfaceNumber        0                          
      bAlternateSetting       7                          
      bNumEndpoints           4                          
      bInterfaceClass       255 Vendor Specific Class    
      bInterfaceSubClass      0                          
      bInterfaceProtocol    255                          
      iInterface              0                          
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x81  EP 1 IN               
        bmAttributes            3                        
          Transfer Type            Interrupt             
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0001  1x 1 bytes            
        bInterval              11                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x82  EP 2 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x1400  3x 1024 bytes         
        bInterval               1                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x83  EP 3 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x00c4  1x 196 bytes          
        bInterval               4                        
      Endpoint Descriptor:                               
        bLength                 7                        
        bDescriptorType         5                        
        bEndpointAddress     0x84  EP 4 IN               
        bmAttributes            1                        
          Transfer Type            Isochronous           
          Synch Type               None                  
          Usage Type               Data                  
        wMaxPacketSize     0x0234  1x 564 bytes          
        bInterval               1                        
Device Qualifier (for other device speed):               
  bLength                10                              
  bDescriptorType         6                              
  bcdUSB               2.00                              
  bDeviceClass            0 (Defined at Interface level) 
  bDeviceSubClass         0                              
  bDeviceProtocol         0                              
  bMaxPacketSize0        64                              
  bNumConfigurations      1                              
Device Status:     0x0000                                
  (Bus Powered)          
