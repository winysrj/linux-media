Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m537nCMV031285
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 03:49:12 -0400
Received: from cp-out11.libero.it (cp-out11.libero.it [212.52.84.111])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m537mxw4017243
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 03:49:00 -0400
Received: from mandoch.ael.it (151.77.238.53) by cp-out11.libero.it (8.5.014)
	(authenticated as rmantovani@libero.it)
	id 483D089100D96D41 for video4linux-list@redhat.com;
	Tue, 3 Jun 2008 09:48:54 +0200
From: Roberto Mantovani - A&L <rmantovani@libero.it>
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="=-knn4pr4Z5u3pjA5khEZK"
Date: Tue, 03 Jun 2008 09:48:52 +0200
Message-Id: <1212479332.32237.9.camel@mandoch.ael.it>
Mime-Version: 1.0
Subject: EM26xx based intra-oral camera : How to make it work
Reply-To: rmantovani@libero.it
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


--=-knn4pr4Z5u3pjA5khEZK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hit to all,

I've been involved in a video project using an USB intra-oral camera
based on a empia em2680 chipset, the camera works fine in linux using
tvtime or mplayer, one of the problems I had was that to make the camera
work I needed to launch the usbreplay program and send to the device
some data 'grabbed' with the windows application 'usbsnoop'.
Now I'm not been able to modify the driver to make the camera works out
of the box, so I modified the usbreplay program to work without the user
interaction, sending automatically the data contained in the file passed
into.
I have attached the source of the modified version of usbreplay, called
usbplay, thinking it could be useful tho others.

Best regards,
--
Roberto Mantovani

--=-knn4pr4Z5u3pjA5khEZK
Content-Disposition: attachment; filename=Makefile
Content-Type: text/x-makefile; name=Makefile; charset=UTF-8
Content-Transfer-Encoding: 7bit

all:
	gcc usbreplay.c -lusb -lmenu -o usbreplay -g
	gcc usbplay.c -lusb -lmenu -o usbplay -g
	gcc scanner.c -lusb -o scanner
clean:
	rm -rf usbreplay scanner

--=-knn4pr4Z5u3pjA5khEZK
Content-Disposition: attachment; filename=usbplay.c
Content-Type: text/x-csrc; name=usbplay.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/*

   USB replay - a nice tool for replaying prepared sniffed usb data

   Copyright (c) 2006 Markus Rechberger <mrechberger@gmail.com>

   Thanks to the ncurses guys, I shamelessly copied their menu example
   and adopted it to fit my needs

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <curses.h>
#include <stdlib.h>
#include <string.h>
#include <menu.h>
#include <usb.h>

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
#define CTRLD   4
#define KEY_RETURN  0x0a
#define KEY_SPACE   0x20 


#ifndef HZ
#define HZ 100
#endif

#define hexdec(x) ((x>=97)?(x-87):(x-48))

int initcurses();
int deinitcurses();

void print_in_middle(WINDOW *win, int starty, int startx, int width, char *string, chtype color);

int addline(char *line,char ***mainmenu){
	char **menu=(*mainmenu);
	int entries=0;
	if(menu==0){
		entries=2;
	} else {
		while(menu[entries++]!=0);
		entries++;
	}
	menu=realloc(menu,sizeof(char *)*entries);
	menu[entries-2]=malloc(sizeof(char)*strlen(line)+1);
	sprintf(menu[entries-2],line);
	menu[entries-1]=0;
	(*mainmenu)=menu; 
	return entries; 
}


char *filterdata(const char *line,int len, int offset){
	char *data;
	int i,d=0;
	data=malloc(len*sizeof(char));
	for(i=offset;i<strlen(line);i+=3){
		if( (line[i]!=0&&((line[i]>='0'&&line[i]<='9')||(line[i]>='a'&&line[i]<='f'))) &&
		   (line[i+1]!=0&&((line[i+1]>='0'&&line[i+1]<='9')||(line[i+1]>='a'&&line[i+1]<='f')))){
			data[d++]=(hexdec(line[i])<<4)|(hexdec(line[i+1]));
		} else 
			break;
	}
	return data;
}

int getep(char *ptr){
	return (int)((hexdec(ptr[0])<<(3*4))|(hexdec(ptr[1])<<(2*4))|(hexdec(ptr[2])<<(4))|hexdec(ptr[3]));
}

int submitline(struct usb_dev_handle *h,const char *line){
	int request;
	int busrequest;
	int windex;
	int index;
	int charlen;
	int ret;
	char *data=0;
	int d;


	if(line[9]=='C') {
		 usb_set_altinterface(h, getep((char*)&line[42]));
	} else if(line[34]=='B' && line[35]=='U') {

		/* parse bulk messages here */
		mvprintw(LINES-1,0,"                                                         ");
		if(line[48]=='<'){
			charlen=(strlen(line)-50)/3;
			mvprintw(LINES-2,0,"reading data from device bytes (%d): ",charlen);
			if(charlen>0) 
				data=filterdata(line,charlen,50);
			else
				data=0;
			ret=usb_bulk_read(h,getep((char*)&line[40]),data,charlen,10*HZ);
			if(ret<0){
				mvprintw(LINES-1,0,"READ FAILED!!! %d   \n",ret);
			} else {
				mvprintw(LINES-1,0,"READ: ");
				if(charlen>0){
					for(d=0;d<charlen;d++){

						printw("%02x ",(unsigned char)data[d]);
					}
				}
			}
			refresh();

		} else {
			charlen=(strlen(line)-50)/3;
			mvprintw(LINES-2,0,"writing data to device bytes   (%d): ",charlen);
			refresh();
			if(charlen>0)
				data=filterdata(line,charlen,50);
			else
				data=0;
			ret=usb_bulk_write(h,getep((char*)&line[40]),data,charlen,HZ);
			if(ret<0)
				mvprintw(LINES-1,0,"WRITE FAILED!!! %d\n",ret);
		}
		if(data){
			free(data);
			data=0;
		}
	} else {
		/* parse control messages here */
		request   = (hexdec(line[34])<<4)|(hexdec(line[35]));
		busrequest= (hexdec(line[37])<<4)|(hexdec(line[38]));
		windex    =((hexdec(line[43])<<12)|(hexdec(line[44]))<<8)|(hexdec(line[40])<<4)|(hexdec(line[41]));
		index     =((hexdec(line[49])<<12)|(hexdec(line[50]))<<8)|(hexdec(line[46])<<4)|(hexdec(line[47]));
		charlen   = (hexdec(line[52])<<4)|(hexdec(line[53]));

		mvprintw(LINES-1,0,"                                                         ");
		attron(COLOR_PAIR(2));
		mvprintw(LINES-3,0,"request: %02x %02x %04x %04x %02x\n",request,busrequest,windex,index,charlen);
		attroff(COLOR_PAIR(2));
		if((request&0xc0)==0xc0){
			mvprintw(LINES-2,0,"reading data from device bytes (%d): ",charlen);
			if(charlen>0)
				data=calloc(charlen,sizeof(char));
			ret=usb_control_msg(h,request,busrequest,windex,index,data,charlen,10*HZ);
			if(ret<0){
				printw("WRITE FAILED!!! %d\n",ret);
			}
			if(charlen>0){
				for(d=0;d<charlen;d++){
					printw("%02x ",(unsigned char)data[d]);
				}
			}
			refresh();

		} else {
			printw("%02x writing data to device!\n",request&0xc0);
			refresh();
			if(charlen>0)
				data=filterdata(line,charlen,63);
			else
				data=0;
			ret=usb_control_msg(h,request,busrequest,windex,index,data,charlen,HZ);
			if(ret<0)
				printw("WRITE FAILED!! %d\n",ret);
		}
		if(data){
			free(data);
			data=0;
		}
	}
	wrefresh(stdscr);
	refresh();
	return 0;
}

int addusbdevice(struct usb_device *device, struct usb_device ***devlist){
	int elements=0;
	struct usb_device **devices=(*devlist);
	printf("adding device:\n");
	
	if(devices==0){
		elements=2;
	} else {
		while(devices[elements++]!=0);
		elements++;
	}
	devices=realloc(devices,sizeof(struct usb_device*)*elements);
	devices[elements-2]=device;
	devices[elements-1]=0;
	(*devlist)=devices;
	return elements;
}

struct usb_dev_handle *selectdevice(){
        ITEM **my_items;
        MENU *my_menu;
        WINDOW *my_menu_win;
	struct usb_bus *bus=0;
	struct usb_device *dev=0;
	struct usb_device *udev=0;
	struct usb_dev_handle *h;
	int c;
	char description[1024];
	struct usb_device **usbmenu=0;
	int devs;
	int i;
	int selected;
	usb_init();
	usb_find_busses();
	usb_find_devices();
	for(bus=usb_get_busses();bus!=0;bus=bus->next){
		for(dev=bus->devices;dev!=0;dev=dev->next){
			if(dev->descriptor.idVendor!=0){
				printf("Found: 0x%04x 0x%04x\n",dev->descriptor.idVendor,dev->descriptor.idProduct);
				if (dev->descriptor.idVendor==0xeb1a
				 && dev->descriptor.idProduct==0x2860) {
					devs=addusbdevice(dev,&usbmenu);
				}
			}
		}
	}
	my_items = (ITEM **)calloc(devs, sizeof(ITEM *)); 
	printf("found devs: %d\n",devs);
	if(devs == 0) {
		printf("No devices attached!\n");
		return NULL;
	}

	if(usbmenu[0]==0) {
		printf("First device is empty!\n");
		return NULL;
	}
	for(i=0;i<devs-1;++i){
		sprintf(description,"VendorID 0x%04x ProductID 0x%04x",usbmenu[i]->descriptor.idVendor,usbmenu[i]->descriptor.idProduct);
		my_items[i]=new_item(strdup(description),strdup(description));
	}

	initcurses();
        
	my_menu = new_menu((ITEM **)my_items);

	menu_opts_off(my_menu, O_SHOWDESC);
        /* Create the window to be associated with the menu */
        my_menu_win = newwin(9, 50, 4, 4);
        keypad(my_menu_win, TRUE);
     
        /* Set main window and sub window */
        set_menu_win(my_menu, my_menu_win);
        set_menu_sub(my_menu, derwin(my_menu_win, 5, 48, 3, 1)); 
        set_menu_format(my_menu, 5, 1);
                        
        /* Set menu mark to the string " * " */
        set_menu_mark(my_menu, " * ");


        /* Print a border around the main window and print a title */
        box(my_menu_win, 0, 0);
        print_in_middle(my_menu_win, 1, 0, 50, "Select USB Device", COLOR_PAIR(1)); 
        mvwaddch(my_menu_win, 2, 0, ACS_LTEE);
        mvwhline(my_menu_win, 2, 1, ACS_HLINE, 48);
        mvwaddch(my_menu_win, 2, 49, ACS_RTEE);
        
        /* Post the menu */
        post_menu(my_menu);
        wrefresh(my_menu_win);

	 
	selected=-1;
#if 0
        while(selected==-1&&(c = wgetch(my_menu_win)) != KEY_F(1)){
               switch(c)
                {       case KEY_DOWN:
                                menu_driver(my_menu, REQ_DOWN_ITEM);
                                break;
                        case KEY_UP:
                                menu_driver(my_menu, REQ_UP_ITEM);
                                break;
                        case KEY_NPAGE:
                                menu_driver(my_menu, REQ_SCR_DPAGE);
                                break;
                        case KEY_PPAGE:
                                menu_driver(my_menu, REQ_SCR_UPAGE);
                                break;
			case KEY_RETURN:
				pos_menu_cursor(my_menu);
				selected=item_index(current_item(my_menu));
				refresh();
				break;

                }
	}
#else
				pos_menu_cursor(my_menu);
				selected=item_index(current_item(my_menu));
				refresh();
		wrefresh(my_menu_win);
#endif
	return usb_open(usbmenu[selected]);
}

int initcurses(){
        /* Initialize curses */
        initscr();
        start_color();
        cbreak();
        noecho();
        keypad(stdscr, TRUE);
        init_pair(1, COLOR_RED, COLOR_BLACK);
        init_pair(2, COLOR_CYAN, COLOR_BLACK);
	return 0;
}

int deinitcurses(){
        endwin();
	return 0;
}

int readfile(char *filename,char ***menuarray){
	char **menu=(*menuarray);
	FILE *file;
	int len;
	char buffer[1025]={0};
	int d;
	int x=0;
	char linebuffer[4096];
	int entries=0;
	file=fopen(filename,"r");
	if(!file){
		printf("invalid filename\n");
		exit(1);
	}
	while((len=fread(buffer,1,1024,file))){
		buffer[len]=0;
		for(d=0;d<len;d++){
			if(buffer[d]=='\n' || buffer[d]==0x0a){
				linebuffer[x]=0;
				if(strlen(linebuffer)>36&&(linebuffer[9]=='C'||linebuffer[9]=='O')&&((linebuffer[34]=='c'||linebuffer[34]=='4')||(linebuffer[34]=='B'&&linebuffer[35]=='U'&&linebuffer[36]=='L'&&linebuffer[37]=='K')||(linebuffer[9]=='C'))){
					entries=addline(linebuffer,&menu);
				}
				x=0;
			} else {
				if(x<4095) /* truncate data here */
					linebuffer[x++]=buffer[d];
			}
		}
	}
	fclose(file);
	(*menuarray)=menu;
	
	return entries;
}

int replaywin(char **menu,int entries,struct usb_dev_handle *h){
        ITEM **my_items;
        int c;                          
	int row,col;
        MENU *my_menu;
        WINDOW *my_menu_win;
        int n_choices, i;
        /* Create items */
	my_items = (ITEM **)calloc(entries, sizeof(ITEM *));
	for(i=0;i<entries;++i)
		my_items[i] = new_item(menu[i],menu[i]);


        /* Crate menu */
        my_menu = new_menu((ITEM **)my_items);
	getmaxyx(stdscr,row,col);
	if(col<80){
		printw("Window width too small (<80 chars)\n");
		getch();
		return -1;
	} 
        /* Create the window to be associated with the menu */
        my_menu_win = newwin(row-3, col, 0, 0);
        keypad(my_menu_win, TRUE);
	menu_opts_off(my_menu, O_SHOWDESC);
     
        /* Set main window and sub window */
        set_menu_win(my_menu, my_menu_win);
        set_menu_sub(my_menu, derwin(my_menu_win, row-7, col-2, 3, 1));
        set_menu_format(my_menu, row-7, 0);
                        
        /* Set menu mark to the string " * " */
        set_menu_mark(my_menu, " * ");


        /* Print a border around the main window and print a title */
        box(my_menu_win, 0, 0);
        print_in_middle(my_menu_win, 1, 0, col, "USB replay", COLOR_PAIR(1));
        mvwaddch(my_menu_win, 2, 0, ACS_LTEE);
        mvwhline(my_menu_win, 2, 1, ACS_HLINE, col-2);
        mvwaddch(my_menu_win, 2, col-1, ACS_RTEE);
        
        /* Post the menu */
        post_menu(my_menu);
        wrefresh(my_menu_win);
#if 0 
        attron(COLOR_PAIR(2));
        mvprintw(LINES - 2, 0, "Use PageUp and PageDown to scoll down or up a page of items");
        mvprintw(LINES - 1, 0, "Arrow Keys to navigate (F1 to Exit)");
        attroff(COLOR_PAIR(2));
        refresh();
#endif

#if 0 
        while((c = wgetch(my_menu_win)) != KEY_F(1))
        {       switch(c)
                {       case KEY_DOWN:
                                menu_driver(my_menu, REQ_DOWN_ITEM);
                                break;
                        case KEY_UP:
                                menu_driver(my_menu, REQ_UP_ITEM);
                                break;
                        case KEY_NPAGE:
                                menu_driver(my_menu, REQ_SCR_DPAGE);
                                break;
                        case KEY_PPAGE:
                                menu_driver(my_menu, REQ_SCR_UPAGE);
                                break;
			case KEY_SPACE:
				pos_menu_cursor(my_menu);
				submitline(h,item_name(current_item(my_menu)));
				refresh();
                                menu_driver(my_menu, REQ_DOWN_ITEM);
				break;
			case KEY_RETURN:
				pos_menu_cursor(my_menu);
				submitline(h,item_name(current_item(my_menu)));
				refresh();
				break;

                }
                wrefresh(my_menu_win);
        }       
#else
        while(1) {
				pos_menu_cursor(my_menu);
				submitline(h,item_name(current_item(my_menu)));
				refresh();
                                if (menu_driver(my_menu, REQ_DOWN_ITEM)
				 == E_REQUEST_DENIED) {
					break;
				}
                wrefresh(my_menu_win);
	}
#endif

        /* Unpost and free all the memory taken up */
        unpost_menu(my_menu);
        free_menu(my_menu);
	return 0;
}

int main(int argc, char **argn){
	char **menu=0;
	int entries=0;
	size_t len;
	int d,x=0;
	struct usb_dev_handle *h;

	if(argc!=2){
		printf("Usage: %s <filename>\n",argn[0]);
		exit(1);
	}

	if((entries=readfile(argn[1],&menu))==0){
		printf("file doesn't look like a proper analyzed usbsnoop logfile, please check the content of that file\n");
		exit(1);
	}
	
	h=selectdevice();
	if( h == NULL ) {
		deinitcurses();
		return -1;
	}
	//usb_set_configuration(h,1);


	replaywin(menu,entries,h);
	deinitcurses();


#if 0
        for(i = 0; i < n_choices; ++i)
                free_item(my_items[i]);
#endif
}

void print_in_middle(WINDOW *win, int starty, int startx, int width, char *string, chtype color)
{       int length, x, y;
        float temp;

        if(win == NULL)
                win = stdscr;
        getyx(win, y, x);
        if(startx != 0)
                x = startx;
        if(starty != 0)
                y = starty;
        if(width == 0)
                width = 80;

        length = strlen(string);
        temp = (width - length)/ 2;
        x = startx + (int)temp;
        wattron(win, color);
        mvwprintw(win, y, x, "%s", string);
        wattroff(win, color);
        refresh();
}



--=-knn4pr4Z5u3pjA5khEZK
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-knn4pr4Z5u3pjA5khEZK--
