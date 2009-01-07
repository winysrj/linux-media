Return-path: <video4linux-list-bounces@redhat.com>
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 7 Jan 2009 11:36:48 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403ECEDD5E0@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [RFC] OMAP3EVM Multi-Media Daughter Card Support
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Hi,

This RFC provides high level design/changes for supporting Multi-Media/Mass-Market/Mistral/Customer Daughter card based on OMAP3 EVM.

Background
==========
OMAP3 EVM doesn't support camera interface, TI and Mistral has developed 
Daughter card on top of OMAP3 EVM which will add support for 

    - TVP5146 decoder, providing BT656 capture support through S-Video/Component/Composite input.
    - Camera/sensor interface (Micron)
    - HSUSB Transceiver USB-83320

Soon the block-diagram, schematics and other details will be available publicly.

Hardware Block Diagram
======================
Below is top level block diagram for the OMAP3 EVM Multi-Media Daughter Card -

  
 
 OMAP 3 Processor                      Multi-Media Daughter Card
    Board
 - - - - - - -               - - - - - - -- - - - - - - - - - - - - - 
| OMAP3530    |             |            - - - - - - <------O S-Vid  |
|             |             |           |           |                |
|         I2C |------------------------>|           |      |O|       |
|             |             |           |           |<-----|O|Compo  |
|             |             |   /|      |  Video    |      |O|site   |
|             |             |  | |      |  Decoder  |                |
|             |             |  | |<-----|  TVP5146  |      |O|       |
|      Camera |             |  | |       - - - - - - <-----|O|Compo  |
|    interface|<---------------| |                         |O|nent   |
|             |             |  | |       - - - - - -                 |
|             |             |  | |<-----|           |                |
|             |             |  | |      |  Micron   |                |
|             |             |  | |      |  Image    |                |
|             |             |   \|      |  Sensor   |                |
|         I2C |------------------------>|           |                |
|             |             |            - - - - - -                 |
|             |             |                                        |
|        HSUSB|             |            - - - - - -                 |
|         HOST|<----------------------->|           |                |
 - - - - - - -              |           |   HSUSB   |                |
                            |           |Transceiver|                |
                            |           |  USB83320 |                |
                            |           |           |                |
                            |            - - - - - -                 |
                            |                                        |
                            |                                        |
                             - - - - - - -- - - - - - - - - - - - - -
                                       
High Level-Software Design
=========================

Following are the files which will add support for Daughter Card -

    - arch/arm/mach-omap2/board-omap3evm-dc.c
        Source file which will handle initialization of the GPMC and similar stuff, registers to the I2C framework for I2C bus 3(TVP5146 interface).
      
    - arch/arm/mach-omap2/board-omap3evm-dc.h
        Corresponding Header file.
        
        
Current implementation/support available
========================================

The basic Daughter card support has been added to the latest git kernel; soon I will be posting the patches for review.

Following things have been tested - 
    - TVP5146: (On top of Sergio's ISP-Camera patch-sets)
        - S-Video
        - Composite
        
    - HSUSB:
        Basic functionality is working.

NOTE: Please note that all the above testing is done on top of ES2.0 silicon version.

TODO - 
    - Component support (Should be very easy)
    - Rigorous testing of TVP5146 and HSUSB.
    - Camera/sensor support

Thanks,
Vaibhav Hiremath


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
